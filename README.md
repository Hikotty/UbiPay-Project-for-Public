# UbiPay-Project-for-Public

## 注意
本レポジトリは、公開用にセキュリティ上問題のない一部のファイルのみを置いています。そのままコードを実行しても動作しない可能性があります。

## UbiPayとは
UbiPayは、奈良先端科学技術大学院大学ユビキタス・コンピューティングシステム研究室内に存在する、飲料や軽食を提供する無人販売所「ユンビニ」で使用できるQRコード決済アプリケーションです。


## 背景
ユンビニはこれまで、全ての決済を現金で行っていました。具体的には、商品の値段分の現金を箱に入れ、商品をそのまま持っていくような形式です。しかし、この方法は簡単であるものの、ユーザにとって次のような課題がありました。

1. 決済のために常に現金が必要となり、利便性が低い
2. 現金をまとめる箱をそのまま置いているため、防犯上の問題がある
3. 誰がいつ、何を買ったのか分からない
4. 在庫がどの程度残っているのか把握できず、仕入れの最適化ができない

## 解決策
以上の課題を解決するために、我々は一定額の現金をデポジットし、その残高を電子的に管理して決済を行うSuicaやPaypayのようなシステムが必要であると考えました。しかし、PayPay等既存の決済システムをユンビニに組み込むためには、申請面で様々な困難が予想され、在庫の管理等のユンビニの課題の解決に必要な機能をカスタマイズしにくいという問題がありました。

そこで、我々は、以上に挙げた課題を解決可能であり、将来的に様々な機能を拡張することを想定したスケーラブルなQRコード決済アプリ、UbiPayを独自開発しました。

## UbiPayのアーキテクチャ
UbiPayのアーキテクチャは図１に示す通りです。

![Alt text](1.png "図１")

UbiPayのシステムは大きく「入金・購入ターミナル/deposit_terminal」、「APIサーバ/server_side」、「ユーザのスマートフォン端末/client_side」の３つの要素から構成されています。

それぞれの機能を完結にまとめると次の通りです。


- 入金・購入ターミナル
    - ユンビニの棚の上に設置されたタッチパネルディスプレイ端末。現金のデポジットと商品の購入操作が可能。RaspberryPiとPythonによって実装

- APIサーバ
    - 入金・購入ターミナルやユーザのスマートフォン端末からのリクエストを操作し、データベースの操作やユーザの登録などを行う。aws上にEC2を立て、Pythonで実装

- ユーザのスマートフォン端末
    - 残高の確認、QRコードの生成・表示、取引履歴の確認等が可能。FlutterでUIを実装。ユーザ管理、ログイン処理にはamazon cognito、amazon amplifyを使用

次に、各要素を詳細に説明します。

### 入金・購入ターミナル/deposit_terminal
入金・購入ターミナルでは、ユーザが実際にユンビニで買い物をしたり、現金を入金（デポジット）する際の処理を行います。このような端末を用意したのは、スマートフォン端末のみで完結させてしまうと、不当な額の入金を検知できなかったり、実際にユンビニまで行かなくとも自身の残高を変更できてしまうといったセキュリティ上の懸念を無くすためです。

入金・購入ターミナルに実装されている機能は主に、

1. ユーザからの指示の入力UI
2. QRコードの読み取り
3. APIサーバに暗号化したリクエストを送る
4. 管理者パスワードの入力

の３つです。
ユーザからの指示を受け取る入力UIには、pysimpleGUIというライブラリを使用し、直感的に操作できるようにしています。

ユーザが商品を購入する際には、商品を手に取り、値段を確認し、自身のスマートフォン端末で生成したQRコードを、端末のカメラにかざすだけで処理が完了する仕様になっています。

QRコードの読み取りはOpen CVを使って実装しています。

APIサーバへのリクエストは、request等一般的な方法によって行っています。この際、セキュリティ性を向上させるために、通信路を予め共有したAES128bitの鍵で暗号化し、またリクエストにサーバで生成した乱数を挿入することで、通信内容を毎回変化させ、リプレイ攻撃を防いでいます。同時に、リクエストにメッセージ認証符号も添付することで、通信路での改ざん検知機能を加えてセキュリティ性を向上させています。

最後に、管理者パスワードの入力ですが、これはユーザが実際に入金した以上の金額をサーバに登録することを防ぐため、ユンビニ管理者が目視で入金額を確認して入金できる仕様にしました。このパスワードはハッシュ化されてRaspberryPI本体に保存され、入力の度にソルトを加えたハッシュ値を計算して照合することで、パスワードを平文で保存することを防いでいます。

### APIサーバ/server_side
APIサーバでは入金・購入ターミナルやユーザのスマートフォン端末から受け取ったリクエストを基にCRUD処理を行ったり、ユーザのログイン状態の管理などを行ったりしています。

APIはPythonのFlaskフレームワークを使用して実装されており、データベースにはMySQLを使用しています。

### ユーザのスマートフォン端末/client_side
ユーザのスマートフォン端末にインストールされるネイティブアプリケーションであり、QRコードの表示や自身の残高の確認、これまでの入出金履歴の確認、残高の送金等の機能を持っています。

アプリケーションはFlutterと呼ばれる、Dart言語で駆動するアプリケーション開発フレームワークで実装しています。FlutterはiOSとAndroidアプリの両方を一度に開発できるクロスプラットフォームのフレームワークであり、効率的な開発に繋げることができました。

### 工夫点
システム設計時の工夫点として、大きく次の３つが挙げられます。

#### 1. ユーザ利便性の追求
UbiPayはユーザの声に基づき、ユーザへの利便性を追求しました。具体的には、様々な国から留学生が集まっている研究室の特性を反映して、世界各国で馴染み深いQRコード決済に対応したり、多言語対応処理を行ったり、ユーザに負担の少ない購入・入金フローの設計を行いました。

#### 2. セキュリティ性
UbiPayはユーザのお金を預かるシステムであるため、時間とのトレードオフの中で可能な限りセキュリティ性の向上に務めています。具体的には、QRコードの失効期限の導入、APIサーバと購入・入金ターミナル間の特に重要性の高い通信に対するメッセージ認証符号や暗号化の導入、不正な入金を防ぐための管理者による確認フローの導入等が挙げられます。

#### 3. スケーラビリティ
UbiPayは将来的なスケーラビリティの確保を設計段階から行っています。具体的には、各要素を疎結合とすることによって新規機能の同時並行開発を可能にし、aws cloudでホスティングすることによって、将来的な分析サービスの導入を容易にしたり、購入・入金機能を物理的に切り離すことで、UbiPayを他の場所に導入することも可能にしています。

## 使用方法

### 入金方法

1. 購入・入金ターミナルの「入金」ボタンをタッチします。
2. スマートフォン端末でUbiPayを起動し、「ホーム」画面の「チャージ」をタッチし、QRコードを表示します。
3. QRコードを購入・入金ターミナルのカメラにかざします。
4. 入金額をタッチパネルに入力します。
5. 管理者パスワードを要求されるため、管理者に入力を依頼します。
6. 入金完了

### 購入方法

1. 購入・入金ターミナルの「購入」ボタンをタッチします。
2. スマートフォン端末でUbiPayを起動し、「ホーム」画面の「チャージ」をタッチし、QRコードを表示します。
3. QRコードを購入・入金ターミナルのカメラにかざします。
4. 購入額をタッチパネルに入力します。
5. 入金完了。

## メンバー
1. バックエンド・フロントエンド開発、全体設計 :　Hikoto Iseda/伊勢田氷琴（M1 Student of Ubiquitous Computing Syatem Lab, at Nara Institute of Science and Technology, Nara, Ikoma）
2. UIデザイン : Nanako Michiura/道浦菜々子（M1 Student of Ubiquitous Computing Syatem Lab, at Nara Institute of Science and Technology, Nara, Ikoma）

# UbiPay-Project-for-Public

## Attention
This repository contains only some files for public use that have no security issues. If you execute the code as is, it may not work.

## What is UbiPay?
UbiPay is a QR code payment application that can be used at "Uunbini," an unmanned sales point for beverages and snacks that exists in the Nara Institute of Science and Technology's Ubiquitous Computing Systems Laboratory.

## Background
Until now, Uunbini has handled all payments in cash. Specifically, customers would put cash for the price of an item in a box and take the item with them. However, while this method is simple, it has the following challenges for users

1. Inconvenience duw to necessity of cash

2. Security issues due to left cash box

3. Management problem due to ignorance of who, what and when purchace occurs

4. Unable to optimize purchasing due to lack of visibility into how much inventory is left.

## Solution
To solve the above issues, we considered the need for a system such as Suica or PayPay, in which a certain amount of cash is deposited and the balance is managed electronically for payment. However, in order to incorporate existing payment systems such as PayPay into Uunbini, we anticipated various difficulties in terms of application, and it was difficult to customize the functions necessary to solve Yunbini's issues such as inventory management.

Therefore, we developed our own scalable QR code payment application, UbiPay, which can solve the above issues and can be expanded with various functions in the future.
## UbiPay architecture
The architecture of UbiPay is shown in Figure 1.

![Alt text](1.png "図１")

UbiPay's system consists of three major elements: "deposit/purchase terminal/deposit_terminal", "API server/server_side" and "user's smartphone terminal/client_side".

Each of these functions can be summarized as follows.

- Deposit and purchase terminal
    - Touch panel display terminals installed on the shelves of the Yumbini. Implemented by RaspberryPi and Python.

- API server
    - EC2 on AWS, implemented in Python

- User's smartphone terminal
    - User's smart phone terminal User can check balance, generate and display QR code, check transaction history, etc. UI is implemented in Flutter. User management and login processes use amazon cognito and amazon amplify.

Next, each element is described in detail.

### deposit_terminal
The deposit/purchase terminal handles the actual purchases and cash deposits made by users at Uunbini. The reason for providing such a terminal is to eliminate security concerns such as the inability to detect improper deposits or the ability to change one's balance without actually going to the Yumbini if the process is completed only with a smartphone terminal.

The main functions implemented in the deposit/purchase terminal are

1. user instruction input UI
2. QR code reading
3. sending encrypted requests to the API server
4. input of administrator password

Input of the administrator password.
The input UI for receiving instructions from the user uses a library called pysimpleGUI for intuitive operation.

When a user purchases a product, the user simply picks up the product, checks the price, and holds up the QR code generated by his/her smartphone terminal to the terminal's camera to complete the process.

The QR code reading is implemented using Open CV.

Requests to the API server are made using common methods such as request. To improve security, the communication channel is encrypted with a 128-bit AES key shared in advance, and a random number generated by the server is inserted into the request to prevent replay attacks by changing the communication content each time. At the same time, a message authentication code is attached to the request to improve security by adding a tamper detection function in the communication channel.

Finally, an administrator password is required. This is designed to prevent users from registering more money on the server than they have actually deposited, so that Yunbini administrators can visually check the amount of money deposited and deposit it. This password is hashed and stored in the RaspberryPI itself, and each time it is entered, the hash value with the salt added is calculated and verified, preventing the password from being stored in plain text.

### server_side

The API server performs CRUD processing based on requests received from the deposit/purchase terminal and the user's smartphone terminal, and manages the user's login status.

The API is implemented using the Python Flask framework, and MySQL is used for the database.

### client_side
It is a native application that is installed on the user's smartphone device and has functions such as displaying QR codes, checking one's balance, checking the history of deposits and withdrawals to date, and transferring balances.

The application is implemented using Flutter, an application development framework driven by the Dart language, which is a cross-platform framework that can develop both iOS and Android applications at once, leading to efficient development. Flutter is a cross-platform framework that can develop both iOS and Android applications at once, leading to efficient development.

### Unique point
The following are three major points to consider when designing a system.

#### 1. Pursuit of user convenience
UbiPay was designed for user convenience based on user feedback. Specifically, reflecting the characteristics of our laboratory, where international students from various countries gather, we designed the system to support QR code payment, which is familiar in many countries around the world, to provide multilingual processing, and to design a purchase and payment flow that is less burdensome for users.

#### 2. Security
Since UbiPay is a system that holds users' money, we strive to improve security as much as possible in a trade-off against time. Specifically, we have introduced an expiration date for QR codes, message authentication codes and encryption for particularly sensitive communications between the API server and the purchase and deposit terminals, and a confirmation flow by administrators to prevent unauthorized deposits.

#### 3. Scalability
UbiPay ensures future scalability from the design stage. Specifically, the loosely coupled elements allow for the concurrent development of new functions, hosting in aws cloud facilitates the future introduction of analysis services, and the physical separation of the purchase and deposit functions allows UbiPay to be deployed in other locations. UbiPay can also be deployed elsewhere by physically separating the purchase and payment functions.

## How to use

### Deposit Methods

1. Touch the "Deposit" button in the Purchase and Deposit Terminal.
2. Start UbiPay on your smartphone device and touch "Charge" on the "Home" screen to display the QR code.
3. Hold the QR code up to the camera of the purchase/deposit terminal.
4. Enter the deposit amount into the touch screen. You will be asked for the administrator password, which you will be asked to enter.
6. Deposit completed

### How to make a purchase

1. Touch the "Buy" button on the Purchase and Deposit Terminal
2. Start UbiPay on your smartphone device and touch "Charge" on the "Home" screen to display the QR code.
3. Hold the QR code up to the camera of the purchase/deposit terminal.
4. Enter the purchase amount into the touch screen.
5. Purchase completed.

## Members
1. Backend,frontend, deposit terminal and design : Hikoto Iseda（M1 Student of Ubiquitous Computing Syatem Lab, at Nara Institute of Science and Technology, Nara, Ikoma）
2. UI design : Nanako Michiura（M1 Student of Ubiquitous Computing Syatem Lab, at Nara Institute of Science and Technology, Nara, Ikoma）


