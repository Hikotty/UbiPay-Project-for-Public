import mysql.connector

def get_user_balance(user_id):
    cnx = None
    deposit_amount = 0
    purchase_amount = 0
    
    # 入金履歴をかき集める
    # historyを使って描き直す
    cnx = mysql.connector.connect(
        user='root',  # ユーザー名
        password='1234',  # パスワード
        host='localhost',  # ホスト名(IPアドレス）
        database = 'ubipaysystem'
        )

    cursor = cnx.cursor(buffered=True)

    sql = ('''
    SELECT amount 
    FROM deposits
    where userid = %s
    ''')

    param = (user_id,)

    cursor.execute(sql,param)

    for amount in cursor:
        deposit_amount += int(amount[0])
    
    #購入履歴をかき集める
    cursor = cnx.cursor(buffered=True)

    sql = ('''
     SELECT items.price
     FROM transactions INNER JOIN items ON transactions.itemname = items.itemname 
     where transactions.userid = %s 
     order by transactions.txdate,transactions.txtime;
    ''')

    param = (user_id,)
    cursor.execute(sql,param)

    for price in cursor:
        purchase_amount += int(price[0])

    #出金履歴を引く
    #受金履歴を足す
    #送金履歴を引く
    
    return deposit_amount - purchase_amount

def get_total_amount(items):
    cnx = None
    res = []

    cnx = mysql.connector.connect(
        user='root',  # ユーザー名
        password='1234',  # パスワード
        host='localhost',  # ホスト名(IPアドレス）
        database = 'ubipaysystem'
        )

    for item in items:
        cursor = cnx.cursor(buffered=True)

        sql = ('''
        SELECT price
        FROM items
        where itemname = %s
        ''')

        params = (item,)

        cursor.execute(sql,params)

        tmp = list(cursor)[0][0]

        res.append(tmp)
        cursor.close()
    return sum(res)
