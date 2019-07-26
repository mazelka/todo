if Rails.application.config.prod_url_option
  Rails.application.routes.default_url_options[:host] = 'mazelka-todo.herokuapp.com'
else
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end
