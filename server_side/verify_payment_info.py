from AES import decrypt_by_AES
from Crypto.Hash import SHA256
import json

def verify_payment_info(user_id,hash1,items):

    with open("PreSharedKey.txt", encoding="utf-8") as file:
        key_info = json.load(file)

    try:
        with open("challenge.txt","r") as file:
            challenge_list = json.load(file)
    except:
        challenge_list = []

    key = key_info['key']
    
    rand = challenge_list[-1]["challenge"]

    message = user_id + ',' + rand
    for item in items:
        message = message + ',' + item

    hash2 = SHA256.new(bytes(message.encode())).digest().hex()

    if hash1 == hash2:
        return True
    else:
        return "Verrification failed"