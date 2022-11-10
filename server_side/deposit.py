import mysql.connector
import deposit_tools
import datetime_tools

def deposit(user_id,amount,hash1):
    existing_user = deposit_tools.get_user_db()
    print(existing_user)
    if user_id not in existing_user:
        deposit_tools.update_user_table()

    cnx = None

    try:
        cnx = mysql.connector.connect(
            user='root',  # ユーザー名
            password='1234',  # パスワード
            host='localhost',  # ホスト名(IPアドレス）
            database = 'ubipaysystem'
        )

        cursor = cnx.cursor()

        sql = ('''
        INSERT INTO deposits 
        (depositrecordid, userid, amount, depositdate, deposittime)
        VALUES
        (%s, %s, %s, %s, %s)
        ''')

        date = datetime_tools.date()
        time = datetime_tools.time()

        params = (hash1, user_id, amount, date, time, )

        print(params)

        cursor.execute(sql, params)
        cnx.commit()
        cursor.close()

        return True
    except Exception as e:
        print(f"Error Occurred: {e}")
        return -1