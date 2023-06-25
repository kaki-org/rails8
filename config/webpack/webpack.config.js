const path = require("path")
const webpack = require("webpack")

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';
// CSSを.cssファイルに切り出す
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// CSSのみを含むエントリーから、exportされたJavaScriptファイルを削除する
// この例では、entry.customは対応する空のcustom.jsファイルを作成する
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');
module.exports = {
  mode,
  devtool: "source-map",
  entry: {
    application: [
      "./app/javascript/application_legacy.js",
      './app/assets/stylesheets/application.scss',
    ],
  },
  module: {
    rules: [
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
    ],
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, '..', '..', "app/assets/builds"),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ]
}
