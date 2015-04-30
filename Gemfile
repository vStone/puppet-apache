source 'https://rubygems.org'

group :rake do
  gem 'rake'
  gem 'puppet-lint', '>=0.2.0'
  gem 'rspec'
  gem 'rspec-puppet'

  puppetversion = ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : ['>= 2.7']
  gem 'puppet', puppetversion
  gem 'puppetlabs_spec_helper'

  nokogiriversion = (RUBY_VERSION =~ /^1.8/ ? '~> 1.5.0' : nil)
  gem 'nokogiri', nokogiriversion
  gem 'puppet-blacksmith'
end
