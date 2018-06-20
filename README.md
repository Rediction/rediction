# Rediction
## 初回ローカル環境セットアップ
1. Docker for Mac インストール
  - https://docs.docker.com/docker-for-mac/install/
2. Docker起動
  - インストールしたDockerを起動させる。
3. DockerをbuildしてImageとContainerを作成
  - 以下のコマンドでBuildする。(最初は少し時間かかるかも)
    - `docker-compose build`
4. DBとか諸々作成
  - 以下のコマンドを実行する。(最初は少し時間かかるかも)
    - `bin/setup`
5. 起動
  - 以下のコマンドで起動する。
    - `docker-compose up`

## よく使うコマンド
### 起動
`docker-compose up`

### バックグラウンドで起動
`docker-compose up -d`

### Railsコマンド
`docker-compose run rails コマンド`

#### 例
```
# マイグレーション
docker-compose run --rm rails rails db:migrate

# テスト(RSpec)実行
docker-compose run --rm -e RAILS_ENV=test rails bundle exec rspec

# Railsコンソール
docker-compose run --rm rails rails c
```

### コンテナに入る
`docker-compose run --rm rails bash`

### コンテナを停止
`docker-compose down`

## ブランチの命名規約
[担当の名前]#[issue番号]

**例**

山田太郎が下画像のissue対応用のブランチを作る場合のブランチは以下の通り
`taro#4`
