class Account < ActiveRecord::Base
  belongs_to :user
  has_many :expenses, dependent: :destroy

  after_create :broadcast
  after_update :broadcast
  after_destroy :broadcast

  protected
  def broadcast
    ActionCable.server.broadcast "user_#{self.user_id}_account", ActiveModel::SerializableResource.new(self).serializable_hash
  end
end
