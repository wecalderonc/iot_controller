# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "iot_controller"
set :repo_url, "git@github.com:devsprocibernetica/iot_controller.git"
set :linked_files, fetch(:linked_files, []).push('config/application.yml', 'config/database.yml', 'config/neo4j.yml', 'config/secrets.yml')
set :linked_dirs,  fetch(:linked_dirs, []).push('node_modules', 'public/assets', 'log')
