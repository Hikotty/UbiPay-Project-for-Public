from Crypto.Hash import SHA256
import json
import AES
import requests
import urllib.request
import get_challenge

def a():
    payload = {
        "content":'6a391cfc-c6b3-4182-9275-81a64bcd56c1'
    }

    payload = json.dumps(payload).encode("utf-8")
    headers = {"Content-Type":"application/json"}

    url = "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/history"
    r = urllib.request.Request(url, data=payload,method="POST",headers=headers)
    with urllib.request.urlopen(r) as response:
        response = response.read().decode("utf-8")
    print(response)
    return response
a()