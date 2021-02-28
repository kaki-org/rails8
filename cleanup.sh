#! /bin/sh

# `rails new` する前の状態に戻すスクリプト。純粋に削除をするだけ
RAILS_LIST="Rakefile
app/
babel.config.js
bin/
config/
config.ru
db/
lib/
log/
node_modules/
package.json
postcss.config.js
public/
spec/
storage/
test/
tmp/
vendor/"

for i in $RAILS_LIST
do
    echo $i
done
