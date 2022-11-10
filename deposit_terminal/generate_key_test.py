from cryptography.fernet import Fernet
import json
import datetime

key = Fernet.generate_key()
time = str(datetime.datetime.now())

res = {
    "time":time,
    "key":str(key.decode('utf-8'))
    }

with open("./PresharedKey.txt", 'w') as file:
    json.dump(res, file, indent=2)