import mysql.connector
import payment_tools
import datetime_tools
from Crypto.Hash import SHA256

def send(from_user_name,from_user_id,to_user_id,amount):
    try:
        cnx = mysql.connector.connect(
            user='root',  # ユーザー名
            password='1234',  # パスワード
            host='localhost',  # ホスト名(IPアドレス）
            database = 'ubipaysystem'
        )

        date = datetime_tools.date()
        time = datetime_tools.time()

        message = ""

        for mes in [from_user_name,from_user_id,to_user_id,amount,date,time]:
            message += " " + mes

        hash = SHA256.new(bytes(message.encode())).digest().hex()

        #cursor = cnx.cursor()            
        for item in items:
            cursor = cnx.cursor()
            sql = ('''
            INSERT INTO remittance
            (remittanceid, from_user_id, from_user_name, to_user_id, remittancedate, remittancetime,amount)
            VALUES
            (%s, %s, %s, %s, %s, %s)
            ''')

            params = (hash, from_user_id, from_user_name, to_user_id, date, time, amount,)

            cursor.execute(sql, params)
            cnx.commit()
            cursor.close()

        return "True"
    except Exception as e:
        print(f"Error Occurred: {e}")
        return "Database error"
