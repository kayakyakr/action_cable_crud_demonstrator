import Em from 'ember'
import Account from 'front/models/account'

export default Em.Route.extend({
  model: function(params){
    return Account.create({name: '', user_id: params.user_id});
  }
});
