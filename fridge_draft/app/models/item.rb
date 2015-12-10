class Item < ActiveRecord::Base
  # usersと多対多の関係になるのをやめたためコメントアウト
  # has_many :user_items
  # has_many :users, :through => :user_items
  belongs_to :user

  # carrierwave用
  mount_uploader :icon, IconUploader
end
