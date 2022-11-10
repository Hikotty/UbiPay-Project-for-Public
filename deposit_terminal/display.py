#coding: utf-8
import PySimpleGUI as sg
import QRcode_reader
import send_deposit_info
import send_payment_info

#変数初期化
password = ""
purchase_item = []
purchase_amount = 0
deposit_amount = 0

itemA_img = "./image/50yen.png"
itemB_img = "./image/100yen.png"
itemC_img = "./image/150yen.png"

def main_frame():
    global purchase_item
    global passord
    global deposit_amount
    global user_id
    global purchase_amount
    purchase_amount = 0
    deposit_amount = 0
    password = ""
    purchase_item = []
    user_id = ""
    sg.theme('DarkPurple1')
    main_layout = [[sg.Column([[sg.Text("UbiPay 購入＆入金ターミナル",size=(20,20),font=("Arial",20))],
            [sg.Button("入金", size=(100,100),font=("Arial",10)),
            sg.Button("購入", size=(100,100),font=("Arial",10))]],justification="c")]]
            
    return sg.Window("メイン画面", main_layout, finalize=True, size=(2550,1370), location=(0, 0))

def purchase_frame():
    global purchase_amount

    sub_layout = [
                   [sg.Column([
                      [sg.Text("購入画面",size=(10,15))],
                      [sg.Text("現在の購入金額"+str(purchase_amount),size=(20,10))],
                      [sg.Text("購入金額を選んでください")],
                      [sg.Button("50円",key='itemA',image_filename=itemA_img,size=(1,1)),
                        sg.Button("100円",key='itemB',image_filename=itemB_img,size=(1,1)),
                        sg.Button("150円",key='itemC',image_filename=itemC_img,size=(1,1))],
                    [sg.Button("入力取り消し",size=(10,10))],
                    [sg.Button("確定",key="purchaseOK")]],
                     justification='c')]]
    
    return sg.Window("入金画面", sub_layout, finalize=True,size=(2550,1370), location=(0, 0))

def admin_frame():
    global password
    
    font = ('Arial', 16)
    numberRow = '1234567890'
    topRow = 'QWERTYUIOP'
    midRow = 'ASDFGHJKL'
    bottomRow = 'ZXCVBNM'

        #　レイアウト
    layout = [
            [sg.Button(c, key=c, size=(4, 2), font=font) for c in numberRow] + [
                sg.Button('rm', size=(4, 2), font=font),
                sg.Button('OK',key="adminOK", size=(4, 2), font=font)],
            [sg.Text(' ' * 4)] + [sg.Button(c, key=c, size=(4, 2), font=font) for c in
                               topRow] + [sg.Stretch()],
            [sg.Text(' ' * 11)] + [sg.Button(c, key=c, size=(4, 2), font=font) for c in
                                midRow] + [sg.Stretch()],
            [sg.Text(' ' * 18)] + [sg.Button(c, key=c, size=(4, 2), font=font) for c in
                                bottomRow] + [sg.Stretch()]]
                                
    return sg.Window("管理者用画面", layout, finalize=True,size=(2550,1370), location=(0, 0))

def deposit_frame():
    
    sub_layout = [
                   [sg.Column([
                      [sg.Text("入金画面",size=(10,15))],
                      [sg.Text("購入金額を選んでください")],
                      [sg.Button("500円",key="dep1",size=(10,10)),
                        sg.Button("1000円",key="dep2",size=(10,10)),
                        sg.Button("5000円",key="dep3",size=(10,10))],
                    [sg.Button("入力取り消し",key="candep",size=(10,10))],
                    [sg.Button("確定",key="inputOK")]],
                     justification='c')]]
    
    return sg.Window("入金画面", sub_layout, finalize=True,size=(2550,1370), location=(0, 0))

window = main_frame()

while True:
    event, values = window.read()
    print(event)

    if event == sg.WIN_CLOSED or event == "Exit":
        break

    elif event == "入金":
        user_id = QRcode_reader.QRcode_reader()
        window.close()
        window = deposit_frame()

    elif event == "購入":
        window.close()
        window = purchase_frame()
        
    elif event == "itemA":
        purchase_amount += 50
        purchase_item.append("A")
        window.close()
        window = purchase_frame()
        
    elif event == "itemB":
        purchase_amount += 100
        purchase_item.append("B")
        window.close()
        window = purchase_frame()
        
    elif event == "itemC":
        purchase_amount += 150
        purchase_item.append("C")
        window.close()
        window = purchase_frame()
        
    elif event == "dep1":
        deposit_amount += 500
        window.close()
        window = deposit_frame()

    elif event == "dep2":
        deposit_amount += 1000
        window.close()
        window = deposit_frame()    
        
    elif event == "dep3":
        deposit_amount += 5000
        window.close()
        window = deposit_frame()    

    elif event == "入力取り消し":
        amount = 0
        window.close()
        window = purchase_frame()
    
    elif event == "inputOK":
        window.close()
        window = admin_frame()
    
    elif event == "purchaseOK":
        user_id = QRcode_reader.QRcode_reader()
        result = send_payment_info.send_payment_info(user_id,purchase_item)
        print(result,7777,type(result))
        if result == "True" or "ture":
            sg.popup('購入完了')
        else:
            sg.popup('購入失敗',custom_text=result)
        user_id = ''
        window.close()
        window = main_frame()
        
    elif len(event) == 1:
        password += event
        print(password)
    elif event == "adminOK":
        if password == "ABC":
            sg.popup('Password Authentification:OK',custom_text="閉じる")
            result = send_deposit_info.send_deposit_info(user_id,deposit_amount)
            if result == 'True':
                sg.popup('入金完了',custom_text="閉じる")
                window.close()
                window = main_frame()
            else:
                sg.popuk('入金失敗'+result,custom_text="閉じる")
                window.close()
                window = main_frame()
        else:
            sg.popup('Password Authentification:Failed',custom_text="閉じる")
            password = ""
    
    elif event == "rm":
        password = ""

# ウィンドウを終了する
window.close()
