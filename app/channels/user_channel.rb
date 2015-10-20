class UserChannel < ApplicationCable::Channel
  def subscribed
  end

  def list
    users = current_user.admin? ? User.all : [current_user]

    users.each { |u| stream_for u }
    stream_from "new_user" if current_user.admin?
    transmit ActiveModel::SerializableResource.new(users).serializable_hash
  end

  def update(params)
    user = User.find(params['id'])
    return unless Ability.new(current_user).can? :update, user

    user.update user_params(params)
  end

  protected

  def user_params(params)
    ActionController::Parameters.new(params).permit(:name, :email)
  end
end
