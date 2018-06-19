# Rediction
## ローカル環境セットアップ
### セットアップ
- Docker for Mac インストール
  - https://docs.docker.com/docker-for-mac/install/

### 起動
`docker-compose up`

### バックグラウンドで起動
`docker-compose up -d`

### Railsコマンド
`docker-compose run rails コマンド`

**例**

- rails c
  - `docker-compose run rails rails c`

### コンテナに入る
`docker-compose run --rm rails bash`

### コンテナを停止
`docker-compose down`
