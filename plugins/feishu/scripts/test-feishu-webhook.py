#!/usr/bin/env python3
import base64
import hashlib
import importlib.util
import json
import pathlib
import subprocess
import sys


REPO_ROOT = pathlib.Path(__file__).resolve().parents[3]
PLUGIN_DIR = REPO_ROOT / "plugins" / "feishu"
WEBHOOK_SCRIPT = PLUGIN_DIR / "scripts" / "feishu_webhook_server.py"
TESTDATA_DIR = PLUGIN_DIR / "testdata" / "webhook"


def load_webhook_module():
    spec = importlib.util.spec_from_file_location("feishu_webhook_server", WEBHOOK_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def load_json(name):
    with (TESTDATA_DIR / name).open("r", encoding="utf-8") as fh:
        return json.load(fh)


def openssl_encrypt_payload(payload, encrypt_key):
    raw = json.dumps(payload, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    key = hashlib.sha256(encrypt_key.encode("utf-8")).digest()
    iv = b"0123456789abcdef"
    proc = subprocess.run(
        [
            "openssl",
            "enc",
            "-aes-256-cbc",
            "-K",
            key.hex(),
            "-iv",
            iv.hex(),
        ],
        input=raw,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.decode("utf-8", errors="replace").strip())
    return base64.b64encode(iv + proc.stdout).decode("ascii")


def main():
    webhook = load_webhook_module()

    challenge = load_json("url_verification.json")
    message = load_json("message_receive_v1.json")

    assert webhook.verify_token(challenge, "test-verification-token")
    assert not webhook.verify_token(challenge, "wrong-token")
    assert webhook.normalize_payload(challenge, None)["challenge"] == "test-challenge-code"
    assert webhook.event_type(message) == "im.message.receive_v1"

    raw_body = json.dumps(challenge, ensure_ascii=False, separators=(",", ":"))
    signature = webhook.calculate_signature("1710000000", "nonce-test", "encrypt-key-test", raw_body)
    assert signature == hashlib.sha256(("1710000000" + "nonce-test" + "encrypt-key-test" + raw_body).encode("utf-8")).hexdigest()

    encrypted = openssl_encrypt_payload(challenge, "encrypt-key-test")
    decrypted = webhook.normalize_payload({"encrypt": encrypted}, "encrypt-key-test")
    assert decrypted == challenge

    print("ok: webhook fixtures and encrypted payload test passed")


if __name__ == "__main__":
    main()
