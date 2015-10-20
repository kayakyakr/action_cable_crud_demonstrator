class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :accounts, dependent: :destroy
  has_many :expenses, through: :accounts

  enum role: [:user, :admin]

  after_create :broadcast_create
  after_update :broadcast

  protected
  def broadcast
    UserChannel.broadcast_to self, ActiveModel::SerializableResource.new(self).serializable_hash
  end

  def broadcast_create
    ActionCable.server.broadcast 'new_user', ActiveModel::SerializableResource.new(self).serializable_hash
  end
end
