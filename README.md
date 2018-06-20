# Rediction
## 初回ローカル環境セットアップ
1. Docker for Mac インストール（以下、参考URL）
  - https://docs.docker.com/docker-for-mac/install/
1. Docker起動
  - インストールしたDockerを起動させる。
1. リポジトリをclone
  - `git clone https://github.com/Rediction/rediction.git`
1. cloneしたディレクトリに移動
  - `cd rediction`
1. DockerをbuildしてImageとContainerを作成
  - `docker-compose build`
1. DBとか諸々作成
  - `bin/setup`
1. 起動
  - `docker-compose up`
1. ブラウザでプロダクトにアクセス
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
[担当の名前]#[issue番号]

**例**

山田太郎がissue（番号４）の対応用のブランチを作る場合の名前は`taro#4`になる。

## masterブランチへのプルリク作成コマンド
`hub pull-request -b master -h develop -m "RELEASE `date '+%Y%m%d%H%M'`"`
