class Expense < ActiveRecord::Base
  belongs_to :account

  after_create :broadcast
  after_update :broadcast
  after_destroy :broadcast

  protected
  def broadcast
    ActionCable.server.broadcast "user_#{self.account.user_id}_expense", ActiveModel::SerializableResource.new(self).serializable_hash
  end
end
