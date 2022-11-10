import json

def inquiry(userid,name,email,inquiry):
    fname = "inquiries.txt"
    
    try:
        with open(fname, "r") as file:
            inquiries = json.load(file)
    except:
        inquiries = []

    inquiries.append({
        "userid":userid,
        "username":name,
        "email":email,
        "content":inquiry,
        "is_read":"False"
    })

    try:
        with open(fname, "w") as file:
            json.dump(inquiries,file, indent=2)
        return "your message was successfully sent"
    except:
        return "failed write inquiry"