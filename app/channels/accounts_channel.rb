class AccountsChannel < ApplicationCable::Channel
  def subscribed
  end

  def list
    stop_all_streams
    users = current_user.admin? ? User.all : User.where(id: current_user.id)
    accounts = current_user.admin? ? Account.all : current_user.accounts

    users.pluck(:id).each { |uid| stream_from "user_#{uid}_account" }
    transmit ActiveModel::SerializableResource.new(accounts).serializable_hash
  end

  def create(params)
    account = Account.new account_params(params)
    return unless Ability.new(current_user).can? :create, account

    account.save
  end

  def update(params)
    account = Account.find(params['id'])
    return unless Ability.new(current_user).can? :update, account

    account.update account_params(params)
  end

  def destroy(params)
    account = Account.includes(:expenses).find(params['id'])
    return unless Ability.new(current_user).can? :destroy, account

    account.destroy
  end

  protected
  def account_params(params)
    ActionController::Parameters.new(params).permit(:name, :user_id)
  end
end
