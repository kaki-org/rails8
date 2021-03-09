const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const provide = require('./plugins/provide')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('erb', erb)
environment.plugins.prepend('provide', provide)
module.exports = environment
