from AES import decrypt_by_AES
from Crypto.Hash import SHA256
import AES
import json

def decrypt(message):
    with open("PreSharedKey.txt", encoding="utf-8") as file:
        key_info = json.load(file)
    key = key_info['key']
    
    decrpted_message = AES.decrypt_by_AES(key,bytes(message.encode()))
    decrpted_message = decrpted_message.decode()
    split_decrypted_message = decrpted_message.split(",")

    # user_id, rand, amount, hash1

    return split_decrypted_message 