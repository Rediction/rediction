CarrierWave.configure do |config|
  # ファイル保存にS3を利用する場合は、S3用の設定を読み込む
  if Rails.application.config.attachment_use_s3
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.config.aws_options[:access_key_id],
      aws_secret_access_key: Rails.application.config.aws_options[:secret_access_key],
      region: Rails.application.config.aws_options[:region]
    }

    config.fog_public = false # S3 objectはprivateのままでアクセス時は期間限定アクセスURLを発行
    config.fog_authenticated_url_expiration = 60 # 発行された期間限定アクセスURLの有効期限を60秒にする
    config.fog_directory = Rails.application.config.aws_options[:s3][:bucket_name]
  elsif Rails.application.config.force_ssl
    config.asset_host = "https://#{Rails.application.config.service_host}"
  else
    config.asset_host = "http://#{Rails.application.config.service_host}"
  end
end
