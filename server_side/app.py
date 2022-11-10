from threading import local
from unicodedata import decomposition
from flask import Flask, request, make_response, jsonify, render_template
import json
import generate_challenge
from pathlib import Path

#自作関数群
import verify_deposit_info
import verify_payment_info
import decrypt
import deposit
import payment
import payment_tools
import history
import inquiry
import withdraw

app = Flask(__name__)

@app.route('/')
def main():
    return "server is alive"

#乱数の送信
@app.route('/challenge', methods=['GET'])
def send_challenge():
    challenge_length = 10
    r = generate_challenge.generate_challenge(challenge_length)
    return make_response(jsonify(r))

#入金処理
@app.route('/deposit', methods=['POST'])
def recieve_deposit():
    data = request.get_json()
    data = decrypt.decrypt(data["content"])
    # user_id, rand, amount, hash1
    user_id = data[0]
    amount = data[2]
    hash1 = data[3]

    verify_result = verify_deposit_info.verify_deposit_info(user_id,amount,hash1)
    if not verify_result:
        return False
    else:
        deposit_result = deposit.deposit(user_id,amount,hash1)
        return make_response(jsonify(deposit_result))

#購入処理
@app.route('/payment', methods=['POST'])
def recieve_payment():
    data = request.get_json()
    data = decrypt.decrypt(data["content"])

    #  hash1, user_id, rand, items, 
    hash1 = data[0]
    user_id = data[1]
    items = data[3:]

    verify_result = verify_payment_info.verify_payment_info(user_id,hash1,items)

    if verify_result:
        payment_result = payment.payment(user_id,hash1,items)
        return make_response(jsonify(payment_result))
    else:
        return make_response(jsonify(verify_result))

#残高問合せ
@app.route('/balance', methods=['POST'])
def balance():
    data = request.get_json()
    user_id = data["content"]
    balance = str(payment_tools.get_user_balance(user_id))
    res = {'message':balance}
    return make_response(jsonify(res))

#残高問合せ
@app.route('/history', methods=['POST'])
def history_():
    data = request.get_json()
    user_id = data["content"]
    tx_list = history.get_user_history(user_id)
    res = {'message':tx_list}
    return make_response(jsonify(res))

#ユーザ問い合わせ
@app.route('/inquiry', methods=['POST'])
def inquiry_():
    data = request.get_json()
    res = inquiry.inquiry(data["userid"],data["username"],data["email"],data["inquiry"])
    ret = {'message':res}
    return make_response(jsonify(ret))

#残金引き出しリクエスト
@app.route('/withdraw', methods=['POST'])
def withdraw_():
    data = request.get_json()
    res = withdraw.withdraw(data["userid"],data["username"],data["email"],data["inquiry"])
    ret = {'message':res}
    return make_response(jsonify(ret))

#送金処置
@app.route('/send', methods=['POST'])
def withdraw_():
    data = request.get_json()
    res = send.send(data["from_user_name"],data["from_user_id"],data["to_user_id"],data["amount"])
    ret = {'message':res}
    return make_response(jsonify(ret))

#ヘルプページへのルーティング処置
@app.route('/help', methods=['GET'])
def help_():
    return render_template('help.html')

#ユーザへのお知らせ処理
@app.route('/notice', method=['GET'])
def notice_():
    return False

if __name__ == '__main__':
    #app.debug = True
    app.run(host="0.0.0.0", port=8080)
    #app.run(host="localhost")
