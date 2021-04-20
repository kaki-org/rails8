const { environment } = require('@rails/webpacker')
// {{ 以下をいれておかないと導入した環境以外では動かない
const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery',
        Popper: ['popper.js', 'default']
    })
)
// }}
module.exports = environment
