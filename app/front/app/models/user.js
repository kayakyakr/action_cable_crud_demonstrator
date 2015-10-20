import Em from 'ember';
import user_channel from 'front/utils/user-channel';

export default Em.Object.extend({
  filtered: false,

  save: function(){
    this.incrementProperty('version');
    user_channel.update(this.getProperties('id', 'name', 'email', 'version'));
  }.observes('name', 'email')
});
