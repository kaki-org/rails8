# rails6
perfect rails6

# 初期構築

ディレクトリにあるファイルは以下の通り

```
Gemfile
Gemfile.lock
README.md
dip.yml
docker-compose.yml
```

bundleを実行して、rails newする。
```
dip bundle
dip rails new .
```

# 色々やろうぜ

`cleanup.sh`を実行する事で`rails new`して出来たファイル群を作成し、新たに`rails new`を実行する事ができる。

# routingを確認する

知らなかったけど、以下でさくっとルーティング情報がわかるみたい。
http://localhost:53000/rails/info/routes

# h2oでEarly Hintsを試す(※)

※注 このセクションはうまく動作しなかった為、参考程度にしておく。
h2oをインストール(`brew install h2o`)して、`/Users/teruo.kakikubo/brew/etc/h2o/h2o.conf`を以下の通りに編集する
```
teruo.kakikubo@C02DN0TXML87 ~/brew/etc/h2o % cat h2o.conf
#listen: 8080
#hosts:
#  "127.0.0.1.xip.io:8080":
#    paths:
#      /:
#        file.dir: /Users/teruo.kakikubo/brew/var/h2o/
hosts:
  localhost:
    listen:
      port: 9090
      ssl:
        certificate-file: /Users/teruo.kakikubo/brew/etc/h2o/localhost.crt
        key-file: /Users/teruo.kakikubo/brew/etc/h2o/localhost.key
    paths:
      /:
        proxy.reverse.url: http://127.0.0.1:53000/
        proxy.preserve-host: ON
access-log: /Users/teruo.kakikubo/brew/var/h2o/access-log
error-log: /Users/teruo.kakikubo/brew/var/h2o/error-log
```
証明書情報を以下のように作成、配置する
```bash
teruo.kakikubo@C02DN0TXML87 ~/brew/etc/h2o % openssl req -nodes -x509 -new \
-days 36500 -subj "/CN=localhost" \
-keyout /Users/teruo.kakikubo/brew/etc/h2o/localhost.key \
-out /Users/teruo.kakikubo/brew/etc/h2o/localhost.crt
Generating a RSA private key
..............................................................................................+++++
............................................................................+++++
writing new private key to '/Users/teruo.kakikubo/brew/etc/h2o/localhost.key'
-----
```
h2oを起動する
```bash
% h2o -c /Users/teruo.kakikubo/brew/etc/h2o/h2o.conf
```