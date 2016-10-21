# これは何か

走ったデータ（気温とGPSデータ）を収集してグラフ化する簡易プログラムです。

# 必要な設定

Google Map APIを使っているので、APIキーを取得し、環境変数`GMAP_API_KEY`に設定してください。

また、Production環境ではAzure SQL Databaseを使うので、接続URLを環境変数`SQL_SERVER_URL`、ユーザ名を環境変数`SQL_SERVER_USER`、パスワードを環境変数`SQL_SERVER_PASS`に設定してください。

さらに、Railsの設定として環境変数`SECRET_KEY_BASE`を設定する必要があります。`rake secret`で値を生成してください。
