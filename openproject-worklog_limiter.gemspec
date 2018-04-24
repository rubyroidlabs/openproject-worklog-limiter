# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/worklog_limiter/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-worklog_limiter"
  s.version     = OpenProject::WorklogLimiter::VERSION
  s.authors     = "OpenProject GmbH"
  s.email       = "info@openproject.org"
  s.homepage    = "https://community.openproject.org/projects/worklog-limiter"  # TODO check this URL
  s.summary     = 'OpenProject Worklog Limiter'
  s.description = "FIXME"
  s.license     = "FIXME" # e.g. "MIT" or "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", "~> 5.0"
end
