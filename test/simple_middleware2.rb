class SimpleMiddleware2
  def initialize(app)
    puts "*" * 50
    puts "* #{self.class} 2initialize(app = #{ app.class })"
    puts "*" * 50
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    puts "*" * 50
    puts "* #{self.class} 2call(body = #{ body })"
    puts "*" * 50
    return [status, headers, body]
  end
end