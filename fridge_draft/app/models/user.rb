class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # 中間テーブルにuser_itemsを用いてitemsと多対多の関係に
  #has_many :user_items
  #has_many :items, :through => :user_items

  # 上記をやめた．つまりある1つのitemが複数のユーザに属するような使い回しの必要性を感じなくなったので．
  has_many :items

  # carrierwave用
  mount_uploader :icon, IconUploader
end
