# Rediction
## 初回ローカル環境セットアップ
1. Docker for Mac インストール（以下、参考URL）
  - https://docs.docker.com/docker-for-mac/install/
2. Docker起動
  - インストールしたDockerを起動させる。
3. リポジトリをclone
  - `git clone https://github.com/Rediction/rediction.git`
4. cloneしたディレクトリに移動
  - `cd rediction`
5. DockerをbuildしてImageとContainerを作成
  - `docker-compose build`
6. DBとか諸々作成
  - `bin/setup`
7. 起動
  - `docker-compose up`
8. ブラウザでプロダクトにアクセス
  - `http://localhost:3000`にアクセスするとRedictionにアクセスできる。

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
[担当の名前]#[TrelloのカードNumber]

**例**

山田太郎がTrelloのカードNumber 4番の対応用のブランチを作る場合の名前は`taro#4`になる。

## masterブランチへのプルリク作成コマンド
*hubがインストールされていることが前提*
```
hub pull-request -b master -h develop -m "RELEASE `date '+%Y%m%d%H%M'`"
```
