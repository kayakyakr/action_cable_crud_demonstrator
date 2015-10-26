require 'rails_helper'

RSpec.describe Expense, type: :model do
  context '#broadcast' do
    let(:user) { create :user }
    let(:account) { create :account, user: user }
    let(:expense) { create :expense, account: account }
    it "fires broadcast on create" do
      expense = build :expense, account: account, id: 1
      expect(ActionCable.server).to receive(:broadcast).with("user_#{user.id}_expense",
        {id: expense.id, description: expense.description, account_id: account.id, comment: expense.comment,
         amount: expense.amount, occurred_at: expense.occurred_at, :destroyed? => false, version: 0}).once
      expense.save
    end

    it "fires broadcast on update" do
      expect(ActionCable.server).to receive(:broadcast).with("user_#{user.id}_expense",
        {id: expense.id, description: "HAHA I BROKE YOUR DESCRIPTION", account_id: account.id, comment: expense.comment,
         amount: expense.amount, occurred_at: expense.occurred_at, :destroyed? => false, version: 1}).once
      expense.update description: "HAHA I BROKE YOUR DESCRIPTION", version: 1
    end

    it "fires broadcast on destroy" do
      expect(ActionCable.server).to receive(:broadcast).with("user_#{user.id}_expense",
        {id: expense.id, description: expense.description, account_id: account.id, comment: expense.comment,
         amount: expense.amount, occurred_at: expense.occurred_at, :destroyed? => true, version: 0}).once
      expense.destroy
    end
  end
end
