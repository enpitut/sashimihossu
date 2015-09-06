Rails.application.routes.draw do

  # homeコントローラのindexメソッドに飛ばせというルーティング。rubyで文の中の # は名前解決演算子。
  root 'home#index'

  # トップページのためのルーティング。コントローラとビューだけあり、モデルは作成していない
  get 'home/index' # bundle exec rails g controller home indexすると自動で追加される
  get 'index' => 'home#index' # localhost:3000/index や localhost:3000/index.html は home#index に飛ばす

  # ユーザ。resources指定は、基本的なルーティングを全て自動で設定してくれる
  #resources :users

  # Device用。自動追加。手動で追加した上記のUserモデルは削除すること。
  devise_for :users

  # item用
  resources :items

  # userとitemの中間用
  resources :user_items
  get 'user_items/user/current_user' => 'user_items#items_by_user'


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
