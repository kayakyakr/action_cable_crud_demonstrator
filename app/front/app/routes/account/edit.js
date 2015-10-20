import Em from 'ember';
import account_channel from 'front/utils/account-channel';

export default Em.Route.extend({
  model: function(params){
    return account_channel.find(params.id);
  }
});
