from cryptography.fernet import Fernet

def decrypt_by_AES(key,message):
    crypt = Fernet(key)
    return crypt.decrypt(message)

def encrypt_by_AES(key,message):
    crypt = Fernet(key)
    return crypt.encrypt(message)