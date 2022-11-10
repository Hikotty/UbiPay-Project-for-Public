def generate_challenge(l):
    import random
    import json
    import datetime

    n = int('9'*l)
    r = 0
    while True:
        r = random.randint(0,n)
        if len(str(r)) >= l:
            break
    try:
        with open("challenge.txt","r") as file:
            challenge_list = json.load(file)
    except:
        challenge_list = []

    challenge_list.append({
        "time":str(datetime.datetime.now()),
        "challenge":str(r)
    })

    with open("challenge.txt","w") as file:
        json.dump(challenge_list, file, indent=2)
    
    return r