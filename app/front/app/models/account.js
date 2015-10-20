import Em from 'ember';
import account_channel from 'front/utils/account-channel';

export default Em.Object.extend({
  errors: Em.computed(function(){ return {}; }),
  filtered: false,

  save: function(){
    let valid = this.valid();
    if(this.get('id') && valid){
      this.incrementProperty('version');
      account_channel.update(this.getProperties('id', 'user_id', 'name', 'version'));
    }
    return valid;
  }.observes('name'),

  create: function(){
    let valid = this.valid();
    if(valid){
      account_channel.create(this.getProperties('user_id', 'name'));
    }
    return valid;
  },

  destroy: function(){
    account_channel.destroy(this.getProperties('id'));
  },

  valid: function(){
    this.set('errors', {});

    if(Em.isBlank(this.get('name'))){ this.set('errors.name', 'cannot be blank.'); }

    return Object.keys(this.get('errors')).length === 0;
  }
});
