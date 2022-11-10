import mysql.connector
from Crypto.Hash import SHA256

def add_item(name,price,date):

    message = name + str(price) + date

    hash = SHA256.new(bytes(message.encode())).digest().hex()

    try:
        cnx = mysql.connector.connect(
            user='root',  # ユーザー名
            password='1234',  # パスワード
            host='localhost',  # ホスト名(IPアドレス）
            database = 'ubipaysystem'
        )

        cursor = cnx.cursor()

        sql = ('''
        INSERT INTO items
        (itemid, itemname ,price ,purchasedate)
        VALUES
        (%s, %s, %s, %s)
        ''')

        params = (hash, name, price, date, )

        cursor.execute(sql, params)
        cnx.commit()
        cursor.close()

        return True
    except Exception as e:
        print(f"Error Occurred: {e}")
        return -1

import mysql.connector
from Crypto.Hash import SHA256

def delete_item(item_id):
    try:
        cnx = mysql.connector.connect(
            user='root',  # ユーザー名
            password='1234',  # パスワード
            host='localhost',  # ホスト名(IPアドレス）
            database = 'ubipaysystem'
        )

        cursor = cnx.cursor()

        sql = ('''
        DELETE FROM items
        WHERE itemid = %s
        ''')

        params = (item_id,)

        cursor.execute(sql, params)
        cnx.commit()
        cursor.close()

        return True
    except Exception as e:
        print(f"Error Occurred: {e}")
        return -1