from Crypto.Hash import SHA256
import json
import AES
import requests
import urllib.request
import get_challenge

def send_deposit_info(user_id,amount):
    # 暗号化に使用する共通鍵（AES128B）の用意
    with open("PreSharedKey.txt", encoding="utf-8") as f:
        key_info = json.load(f)

    key = key_info['key']

    rand = get_challenge.get_challenge().strip()

    # 署名の生成
    # 送るのは，IDと乱数と署名

    message = user_id + ',' + rand + "," + str(amount)

    hash = SHA256.new(bytes(message.encode()))

    send_message = message + "," + hash.digest().hex()
    send_message = bytes(send_message.encode())

    encrypted_send_message = AES.encrypt_by_AES(key,send_message).decode()

    payload = {
        "content":str(encrypted_send_message)
    }

    payload = json.dumps(payload).encode("utf-8")
    headers = {"Content-Type":"application/json"}

    url = "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/deposit"
    r = urllib.request.Request(url, data=payload,method="POST",headers=headers)
    with urllib.request.urlopen(r) as response:
        response = response.read().decode("utf-8")
    return response
