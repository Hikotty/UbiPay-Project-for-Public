import datetime
import mysql.connector

def get_user_history(user_id):
    cnx = None
    deposit_amount = 0
    
    # 購入履歴をかき集める
    cnx = mysql.connector.connect(
        user='root',  # ユーザー名
        password='1234',  # パスワード
        host='localhost',  # ホスト名(IPアドレス）
        database = 'ubipaysystem'
        )

    cursor = cnx.cursor(buffered=True)

    sql = ('''
           select transactions.txid, transactions.itemname,items.price,transactions.txdate,transactions.txtime
           from transactions left outer join items on transactions.itemname = items.itemname 
           where transactions.userid = %s 
           order by transactions.txdate, transactions.txtime;
    ''')

    param = (user_id,)

    cursor.execute(sql,param)

    cursor_list = []
    tx_list = []

    for (txid,itemname,price,txdate,txtime) in cursor:
        cursor_list.append([txid,itemname,price,txdate,txtime])

    # 入金履歴をかき集める
    cnx = mysql.connector.connect(
        user='root',  # ユーザー名
        password='1234',  # パスワード
        host='localhost',  # ホスト名(IPアドレス）
        database = 'ubipaysystem'
        )

    cursor = cnx.cursor(buffered=True)

    sql = ('''
           select depositrecordid, amount, depositdate, deposittime 
           from deposits 
           where userid=%s
           order by depositdate, deposittime;
    ''')

    param = (user_id,)
    cursor.execute(sql,param)
    cursor_list2 = []
    for (depositrecordid,amount,depositdate,deposittime) in cursor:
        a = depositdate.strftime('%Y-%m-%d') + " " + str(deposittime).replace(":","")
        dte = datetime.datetime.strptime(a, '%Y-%m-%d %H%M%S')
        print(dte)
        cursor_list2.append([dte,depositdate,deposittime,amount,"deposit",depositrecordid])


    tmp_id = cursor_list[0][0]
    tmp_price = cursor_list[0][2]
    tmp_date = cursor_list[0][3]
    tmp_time = cursor_list[0][4]

    for i in range(1,len(cursor_list)):
        if cursor_list[i][0] != tmp_id:
            #dte = datetime.datetime.strptime(tmp_date.strftime('%Y/%m/%d')+tmp_time, '%Y/%m/%d %h:%m:%s')
            a = tmp_date.strftime('%Y/%m/%d') + " " + str(tmp_time).replace(":","")
            dte = datetime.datetime.strptime(a, '%Y/%m/%d %H%M%S')
            tx_list.append([dte,tmp_date.strftime('%Y/%m/%d'),str(tmp_time),tmp_price,"purchase",tmp_id])
            tmp_id = cursor_list[i][0]
            tmp_price = cursor_list[i][2]
            tmp_date = cursor_list[i][3]
            tmp_time = cursor_list[i][4]
        else:
            tmp_price += cursor_list[i][2]
    
    history = tx_list + cursor_list2
    history.sort(reverse=True)
    res = []

    for tx in history:
        res.append({
            "tx":tx[-2],
            "txid":tx[-1],
            "date":str(tx[1]),
            "time":str(tx[2]),
            "amount":str(tx[3]),
        })

    return res
