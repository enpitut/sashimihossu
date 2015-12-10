Rails.application.routes.draw do

  # トップページはhomeコントローラのindexメソッドに飛ばせというルーティング。rubyで文の中の # は名前解決演算子。
  root 'home#index'

  # トップページのためのルーティング。コントローラとビューだけあり、モデルは作成していない
  get 'home/index' # bundle exec rails g controller home indexすると自動で追加される
  get 'index' => 'home#index' # localhost:3000/index や localhost:3000/index.html は home#index に飛ばす

  # ユーザ。resources指定は、基本的なルーティングを全て自動で設定してくれる
  #resources :users

  # Device用。自動追加。手動で追加した上記のUserモデル用ルーティングは削除すること(Usersモデル自体は使用する)
  devise_for :users

  # 現在ログイン中のユーザidを返すapi
  get 'items/current_user_id' => 'items#current_user_id'

  # item用
  # items/index_by_user.jsonというurlにアクセスするとitems#index_by_userメソッドが叩かれ，
  # 現在ログイン中のユーザidが所持するアイテム一覧がjsonで返る．
  # resourcesより前に定義すること．そうしないと，通常のitems/1といったルーティングと混同されてしまう．
  get 'items/index_by_user' => 'items#index_by_user'
  get 'items/show_recipes' => 'items#show_recipes'
  resources :items

  # freshness用
  get 'freshnesses/freshness_by_name' => 'freshnesses#freshness_by_name'
  resources :freshnesses

  # userとitemをとりもち，カレンダーのイベントデータのストレージとしてもはたらくuser_items用．
  # user_itemsコントローラのitems_by_userは，現在ログインしているユーザが所持するアイテムをとってくるメソッド．
  # apiとしてアクセスしやすくするために，user_items/user/current_userという形でこれを叩けるようにしている．
  #resources :user_items
  #get 'user_items/user/current_user' => 'user_items#items_by_user'




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
