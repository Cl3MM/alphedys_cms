source 'http://rubygems.org'

group :development do 
  gem 'pry'
#  gem 'pry-remote'
#  gem 'pry-nav'
end

gem 'rails'
gem 'simple_form'
gem "paperclip"
gem 'vestal_versions', :git => 'git://github.com/laserlemon/vestal_versions'
gem "breadcrumbs_on_rails", "~> 2.2.0"
#gem "thin"
#gem 'puma'
gem 'puma', git: "git://github.com/puma/puma.git"

gem 'kaminari'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'execjs'
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'therubyracer', :platform => :ruby

  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0', :require => "bcrypt"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem "rspec-rails", :group => [:test, :development]
group :test do
  # Pretty printed test output
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem 'capybara'
  gem 'turn'
end
