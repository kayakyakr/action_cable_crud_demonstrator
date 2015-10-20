import Em from 'ember';
import Expense from 'front/models/expense';

export default Em.Component.extend({
  addNew: null,

  users: function(){
    let users = this.get('allUsers').filterBy('filter', true);
    if(Em.isEmpty(users)){
      return this.get('allUsers');
    }
    return users;
  }.property('allUsers.@each.filter'),

  accounts: function(){
    let user_ids = this.get('users').mapBy('id');
    let accounts = this.get('allAccounts').filterBy('filter', true);
    if(Em.isEmpty(accounts)){ accounts = this.get('allAccounts'); }
    return accounts.filter((a) => user_ids.contains(Em.get(a, 'user_id')));
  }.property('users.[]', 'allAccounts.@each.user_id', 'allAccounts.@each.filter'),

  expenses: function(){
    let account_ids = this.get('accounts').mapBy('id');
    return this.get('allExpenses').filter((e) => account_ids.contains(Em.get(e, 'account_id'))).sortBy('occurred_at');
  }.property('accounts.[]', 'allExpenses.@each.account_id', 'allExpenses.@each.occurred_at'),

  date: function(){
    return moment(this.get('addNew.occurred_at')).local().format('YYYY-MM-DDTHH:mm:ss');
  }.property('addNew.occurred_at'),

  actions: {
    updateDate: function(e){
      this.set('addNew.occurred_at', moment($(e.target).val()).utc().toISOString());
    },

    addNew: function(){
      this.set('addNew', Expense.create({account_id: this.get('accounts.0.id'), occurred_at: moment().toISOString()}));
    },

    saveNew: function(){
      this.get('addNew').create();
      this.set('addNew', null);
    },

    cancelNew: function(){
      this.set('addNew', null);
    }
  }
});
