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
http://rails6.lvh.me:53000/rails/info/routes
