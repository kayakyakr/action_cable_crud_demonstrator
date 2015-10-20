import Em from 'ember';

export default Em.Component.extend({
  accounts: function(){
    return this.get('allAccounts').filterBy('user_id', this.get('model.id'));
  }.property('model.id', 'allAccounts.@each.user_id'),

  actions: {
    filter: function(model){
      model.toggleProperty('filter');
    }
  }
});
