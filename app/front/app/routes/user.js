import Em from 'ember';
import user_channel from 'front/utils/user-channel';

export default Em.Route.extend({
  model: function(params){
    return user_channel.find(params.id);
  }
});
