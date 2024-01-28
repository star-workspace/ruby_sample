# FROM：使用するイメージ、バージョン
FROM ruby:3.3
# 公式→https://hub.docker.com/_/ruby

ARG RUBYGEMS_VERSION=3.5.3

#作業用ディレクトリ作成
ENV APP_ROOT /app
RUN mkdir $APP_ROOT

# WORKDIR：作業ディレクトリを指定
WORKDIR $APP_ROOT

# ローカルのGemfileをコンテナ内の/app/Gemfileにコピー
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

# RubyGemsをアップデート
RUN gem update --system ${RUBYGEMS_VERSION} && \
    bundle install

COPY . $APP_ROOT

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3001

# CMD:コンテナ実行時、デフォルトで実行したいコマンド
# Rails サーバ起動
CMD ["rails", "server", "-b", "0.0.0.0"]