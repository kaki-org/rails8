// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
const $ = require("jquery")
// $(() => $("body").html("hello jquery2"))

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", function(){
    console.log("turbolinks:load fire")
})
document.addEventListener("turbolinks:click", function(){
    console.log("turbolinks:click fire")
})
document.addEventListener("turbolinks:request-start", function(){
    console.log("turbolinks:request-start fire")
})

import "controllers"

require("trix")
require("@rails/actiontext")