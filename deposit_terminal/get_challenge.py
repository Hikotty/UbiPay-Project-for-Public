def get_challenge():
    import requests

    url = "http://35.78.201.89:8080/challenge"
    r = requests.get(url)
    return r.text