source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2.0"
# Use sqlite3 as the database for Active Record
gem "mysql2"
# Use Puma as the app server
gem "puma", "~> 3.11"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
gem "redis"
gem "redis-rails"
# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Validationメッセージを日本語化するために利用するもの
gem "rails-i18n"
# slim記法を利用できるようにしてくれるもの
gem "slim-rails"
# annotateと連携して、migrationのコメントをmodelなどに表示するためのもの
gem "migration_comments"
# ログイン時にOAuth認証を利用できるようにするもの
gem "omniauth-oauth2"
# GoogleアカウントでOAuth認証できるようにするもの
gem "omniauth-google-oauth2"
# エラー通知をしてくれるようにするもの
gem "rollbar"
# enumでi18nを利用できるようにするもの
gem "enum_help"
# Decoratorを利用できるようにするもの
gem "active_decorator"
# CSSやJSをまとめてくれるモジュールハンドラー。ES6やReact, Vueを使えるようにするもの。
gem "webpacker"
# activerecordでバルクインサートを利用できるようにするもの
gem "activerecord-import"
# ドメインやパスを判定してリダイレクトをできるようにするもの
gem 'rack-rewrite'
# IPアドレス閲覧制限をおこなえるようにするもの
gem 'rack-attack'

##
# 管理画面用
# BootstrapをImportして利用できるようにするもの
gem "bootstrap-sass"
# ページネーションを簡易的にできるようにするもの
gem "kaminari"
# FormBuilderの一種でform_helperをシンプルな形式で記述できるというもの
gem "simple_form"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # RSpecを利用できるようにするもの
  gem "rspec-rails"
  # FactoryBotを利用できるようにするもの
  gem "factory_bot_rails"
  # rubocopの良い感じの設定をしてくれるライブラリ http://blog-ja.sideci.com/entry/2016/10/03/171816
  gem "meowcop", require: false
  # コーディング規約違反のチェックツール
  gem "rubocop", require: false
  # テストのカバレッジを見える化してくれるもの
  gem "simplecov", require: false
  # Controllerのテストでassignなどを使えるようにするもの
  gem "rails-controller-testing"
  # テスト結果を整形できたりするCI用のもの
  gem "rspec_junit_formatter"
  # JSONのフォーマット検証を感知的にできるようにするもの(主にAPI用)
  gem "json_spec"
  # デバック用 binding.pry で止めれる
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-doc"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  # メール送信したときに、ブラウザで送信したメールを自動的に開いてくれるもの
  gem "letter_opener"
  # letter_openerのページを閲覧できるURIを提供する
  gem "letter_opener_web"
  # スキーマ情報を書く ActiveRecord の定義クラスにコメントしてくれるもの
  gem "annotate"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
