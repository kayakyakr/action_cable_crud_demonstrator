import cable from './cable';
import User from 'front/models/user';

var resolve, promise = new Promise((r) => { resolve = r; });
var channel = cable.subscriptions.create('UserChannel', {
  list: function(arr){
    this.arr = arr;
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

    data.forEach((u) => {
      let user = this.arr.findBy('id', u.id);
      if(!user){ user = this.arr.findBy('id', null); }
      if(user){
        user.setProperties(u);
      } else {
        this.arr.addObject(User.create(u));
      }
    });
  }
});

export default channel;
