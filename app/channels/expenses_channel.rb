class ExpensesChannel < ApplicationCable::Channel
  def subscribed
  end

  def list
    stop_all_streams
    users = current_user.admin? ? User.all : User.where(id: current_user.id)
    expenses = current_user.admin? ? Expense.all : current_user.expenses

    users.pluck(:id).each { |uid| stream_from "user_#{uid}_expense" }
    transmit ActiveModel::SerializableResource.new(expenses).serializable_hash
  end

  def create(params)
    expense = Expense.new expense_params(params)
    return unless Ability.new(current_user).can? :create, expense

    expense.save
  end

  def update(params)
    expense = Expense.includes(:account).find(params['id'])
    return unless Ability.new(current_user).can? :update, expense

    expense.update expense_params(params)
  end

  def destroy(params)
    expense = Expense.includes(:account).find(params['id'])
    return unless Ability.new(current_user).can? :destroy, expense

    expense.destroy
  end

  protected
  def expense_params(params)
    ActionController::Parameters.new(params).permit(:description, :occurred_at, :amount, :comment, :account_id)
  end
end
