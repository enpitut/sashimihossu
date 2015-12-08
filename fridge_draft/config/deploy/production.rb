# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# 役割ごとにサーバを指定．デフォルトで付いていた末尾はコメントアウトした．
# また，1つのロールにサーバを複数指定することも可能．その場合はスペースで分かち書きする
role :app, %w{tsuruta@fukachun.iplab.cs.tsukuba.ac.jp}#, my_property: :my_value
role :web, %w{tsuruta@fukachun.iplab.cs.tsukuba.ac.jp}#, other_property: :other_value
role :db,  %w{tsuruta@fukachun.iplab.cs.tsukuba.ac.jp}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
# デプロイ先サーバにアクセスするための共通で使用するssh設定
# サーバが1つならこちらで設定してしまえば完了
 set :ssh_options, {
   keys: %w(/Users/sky-legacy/.ssh/id_rsa.pub), # サーバにあらかじめ登録しておいたこちら側の鍵
   forward_agent: true # サーバーから直接githubのプライベートリポジトリにアクセスするためにtrueに
   #auth_methods: %w(password)
 }
# ロールごとにサーバが異なって複数あるなら，以下の書き方を複数使ってサーバを登録する
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
