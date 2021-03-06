# This file is used by Rack-based servers to start the application.

require 'rack'
require_relative "app"
require_relative "simple_middleware"
require_relative "simple_middleware2"

use Rack::Runtime
use SimpleMiddleware
use SimpleMiddleware2
run App.new
