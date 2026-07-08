# app/controllers の注意点

- TicketsController#new が RoutingError を raise しているのは意図的。チケットはイベント show 画面から直接 POST で作る設計で、new 画面は存在しない。フォーム描画に「修正」しない
