from Crypto.Hash import SHA256
import json

def verify_deposit_info(user_id,amount,hash1):

    try:
        with open("challenge.txt","r") as file:
            challenge_list = json.load(file)
    except:
        challenge_list = []

    challenge = challenge_list[-1]["challenge"]

    message = user_id + ',' + challenge + "," + str(amount)

    hash2 = SHA256.new(bytes(message.encode())).digest().hex()

    if hash1 == hash2:
        return True
    else:
        return False