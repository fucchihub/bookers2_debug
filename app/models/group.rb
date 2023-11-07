class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, source: :user
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image

  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end


#belongs_to :owner, class_name: 'User'
#def is_owned_by?(user)
#owner.id == user.id
#end

#def includesUser?(user)
#group_users.exists?(user_id: user.id)
#end

end
