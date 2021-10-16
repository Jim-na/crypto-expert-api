# frozen_string_literal: true

require 'http'
require 'yaml'

BASIC_URL = "https://api.binance.com/api/v3/"
config = YAML.safe_load(File.read('config/secrets.yml'))

def binance_api(path)
  "#{BASIC_URL}#{path}"
end

def call_binance_url(url)
  HTTP.headers('Content-Type' => 'application/json').get(url)
end

project_url = binance_api('exchangeInfo')
binance_response[project_url] = call_binance_url(config, project_url)
puts binance_response


# gh_response = {}
# gh_results = {}

# ## HAPPY project request
# project_url = gh_api_path('repos/soumyaray/YPBT-app')
# gh_response[project_url] = call_gh_url(config, project_url)
# project = gh_response[project_url].parse

# gh_results['size'] = project['size']
# # should be 551

# gh_results['owner'] = project['owner']
# # should have info about Soumya

# gh_results['git_url'] = project['git_url']
# # should be "git://github.com/soumyaray/YPBT-app.git"

# gh_results['contributors_url'] = project['contributors_url']
# # "should be https://api.github.com/repos/soumyaray/YPBT-app/contributors"

# contributors_url = project['contributors_url']
# gh_response[contributors_url] = call_gh_url(config, contributors_url)
# contributors = gh_response[contributors_url].parse

# gh_results['contributors'] = contributors
# contributors.count
# # should be 3 contributors array

# contributors.map { |c| c['login'] }
# # should be ["Yuan-Yu", "SOA-KunLin", "luyimin"]

# ## BAD project request
# bad_project_url = gh_api_path('soumyaray/foobar')
# gh_response[bad_project_url] = call_gh_url(config, bad_project_url)
# gh_response[bad_project_url].parse # makes sure any streaming finishes

# File.write('spec/fixtures/github_results.yml', gh_results.to_yaml)