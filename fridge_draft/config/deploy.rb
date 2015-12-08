# ここはcapistranoのバージョンによって変わり最初から書かれているので変更しない
# config valid only for current version of Capistrano
lock '3.4.0'

# railsアプリケーション名
set :application, 'fridge_draft'

# githubのurl．プロジェクトのgitホスティング先を指定する
set :repo_url, 'git@github.com:enpitut/sashimihossu.git'

# デプロイするブランチをmasterに固定
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'

# デプロイ先サーバーにおいて実際にデプロイ先となるディレクトリ．フルパスで指定
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/fridge_draft'

# バージョン管理システムはgit
# Default value for :scm is :git
set :scm, :git

# ログは整形して表示
# Default value for :format is :pretty
set :format, :pretty

# ログは詳細に表示
# Default value for :log_level is :debug
set :log_level, :debug

# pseudo-ttyを利用するかどうか．
# リモートでsudoコマンドを実行する際に sudo: no tty present and no askpass program specified というエラーが出る場合はこれを設定するとよい
# Default value for :pty is false
# set :pty, true

# デプロイ先サーバに保持される数リリース分のバージョン間で共通で使用したいファイルを設定
# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# デプロイ先サーバに保持される数リリース分のバージョン間で共通で使用したいディレクトリを設定
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/backup', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/assets')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# デプロイ先サーバに5リリース分の履歴を保持しておく
# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
