import cable from './cable';
import User from 'front/models/user';
import account_channel from './account-channel';
import expense_channel from './expense-channel';

var resolve, promise = new Promise((r) => { resolve = r; });
var channel = cable.subscriptions.create('UserChannel', {
  list: function(arr){
    if(arr){ this.arr = arr; }
    this.perform('list');
  },

  update: function(data){
    this.perform('update', data);
  },

  find: function(id){
    return Promise.resolve(promise).then(() => {
      return this.arr.findBy('id', parseInt(id));
    });
  },

  received: function(data){
    resolve();
    // set data received
    if(data.constructor !== Array){ data = [data]; }

    var had_new = false,
        can_reload = this.arr.length > 0;

    data.forEach((u) => {
      let user = this.arr.findBy('id', u.id);
      if(!user){ user = this.arr.findBy('id', null); }
      if(user){
        if(user.get('version') < u.version){
          user.setProperties(u);
        }
      } else {
        had_new = true;
        this.arr.addObject(User.create(u));
      }
    });

    if(can_reload && had_new){
      this.list();
      account_channel.list();
      expense_channel.list();
    }
  }
});

export default channel;
