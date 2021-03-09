#! /bin/sh

# `rails new` する前の状態に戻すスクリプト。純粋に削除をするだけ
RAILS_LIST="Rakefile
app/
bin/
config/
config.ru
db/
lib/
log/
public/
spec/
storage/
test/
tmp/
vendor/"

for i in $RAILS_LIST
do
    echo "remove recursively" $i
    rm -rf $i
done
# webpackerアプリの作成
dip bash -c "rails new . --database mysql"
cp database.yml.github-actions config

