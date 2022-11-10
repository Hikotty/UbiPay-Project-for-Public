import mysql.connector
import payment_tools
import datetime_tools

def payment(user_id,hash1,items):

    balance = payment_tools.get_user_balance(user_id)
    purchase_amount = payment_tools.get_total_amount(items)
    print(balance,purchase_amount)

    if balance < purchase_amount:
        return "Purchase amount exceed"
    else:
        try:
            cnx = mysql.connector.connect(
                user='root',  # ユーザー名
                password='1234',  # パスワード
                host='localhost',  # ホスト名(IPアドレス）
                database = 'ubipaysystem'
            )

            date = datetime_tools.date()
            time = datetime_tools.time()

            #cursor = cnx.cursor()            
            for item in items:
                cursor = cnx.cursor()
                sql = ('''
                INSERT INTO transactions
                (txid, itemname, userid, txdate, txtime)
                VALUES
                (%s, %s, %s, %s, %s)
                ''')

                params = (hash1, item, user_id, date, time,)

                cursor.execute(sql, params)
                cnx.commit()
                cursor.close()

            return True
        except Exception as e:
            print(f"Error Occurred: {e}")
            return "Database error"
