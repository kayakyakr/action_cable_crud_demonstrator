import Em from 'ember';
import expense_channel from 'front/utils/expense-channel';

export default Em.Object.extend({
  errors: Em.computed(function(){ return {}; }),

  save: function(){
    let valid = this.valid();
    if(this.get('id') && valid){
      this.incrementProperty('version');
      expense_channel.update(this.getProperties('id', 'account_id', 'description', 'comment', 'occurred_at', 'amount', 'version'));
    }
    return valid;
  }.observes('account_id', 'description', 'comment', 'occurred_at', 'amount'),

  create: function(){
    let valid = this.valid();
    if(valid){
      expense_channel.create(this.getProperties('user_id', 'account_id', 'description', 'comment', 'occurred_at', 'amount'));
    }
    return valid;
  },

  destroy: function(){
    expense_channel.destroy(this.getProperties('id'));
  },

  valid: function(){
    this.set('errors', {});

    if(Em.isBlank(this.get('occurred_at'))){ this.set('errors.occurred_at', 'cannot be blank.'); }

    return Object.keys(this.get('errors')).length === 0;
  }
});
