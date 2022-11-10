import subprocess
import json
import mysql.connector

def get_user_pool():
    cp = subprocess.run(['aws','cognito-idp','list-users', '--user-pool-id','ap-northeast-1_GOttrtBF6'], capture_output=True)
    data = cp.stdout
    data = data.decode('utf-8')
    
    data = json.loads(data)
    users = []
    for user in data["Users"]:
        #print(user)
        users.append((
            user["Username"],user["Attributes"][2]["Value"],user["UserCreateDate"][:10].replace('-',''),user["UserCreateDate"][11:19]
        ))
    return users

def get_user_db():
    users = []
    cnx = None

    cnx = mysql.connector.connect(
        user='root',  # ユーザー名
        password='1234',  # パスワード
        host='localhost',  # ホスト名(IPアドレス）
        database = 'ubipaysystem'
        )

    cursor = cnx.cursor()

    sql = ('''
    SELECT * FROM users
    ''')


    cursor.execute(sql)
    
    for (userid, email, usercreatedate, usercreatetime) in cursor:
        users.append(userid) 
    cursor.close()
    return users

def update_user_table():
    current_users = get_user_pool()
    existing_users = get_user_db()
    new_users = []

    for user in current_users:
        if user[0] not in existing_users:
            new_users.append(user)
    
    #print(new_users)
    if len(new_users) > 0:
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
            INSERT INTO users 
            (userid, email,usercreatedate,usercreatetime)
            VALUES
            (%s, %s, %s, %s)
            ''')

            cursor.executemany(sql, new_users)
            cnx.commit()
            cursor.close()

            return True
        except Exception as e:
            print(f"Error Occurred: {e}")
            return -1
    else:
        return False