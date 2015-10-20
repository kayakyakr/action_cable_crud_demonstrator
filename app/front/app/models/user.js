import Em from 'ember';
import user_channel from 'front/utils/user-channel';

export default Em.Object.extend({
  filtered: false,

  save: function(){
    user_channel.update(this.getProperties('id', 'name', 'email'));
  }.observes('name', 'email')
});
