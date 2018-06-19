
FROM mysql:5.7

ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes
ENV MYSQL_ROOT_PASSWORD=""
ENV MYSQL_USER="root"

RUN apt-get update && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

RUN { \
    echo '[mysqld]'; \
    echo 'character-set-server=utf8mb4'; \
    echo 'collation-server=utf8mb4_bin'; \
    echo '[client]'; \
    echo 'default-character-set=utf8mb4'; \
} > /etc/mysql/conf.d/charset.cnf
