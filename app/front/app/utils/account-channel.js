import cable from './cable';
import Account from 'front/models/account';

var resolve, promise = new Promise((r) => { resolve = r; });
var channel = cable.subscriptions.create('AccountsChannel', {
  list: function(arr){
    this.arr = arr;
    this.perform('list');
  },

  update: function(data){
    this.perform('update', data);
  },

  create: function(data){
    this.perform('create', data);
  },

  destroy: function(data){
    this.perform('destroy', data);
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

    data.forEach((a) => {
      let account = this.arr.findBy('id', a.id);
      if(!account){ account = this.arr.findBy('id', null); }
      if(account){
        if(a['destroyed?']){
          this.arr.removeObject(account);
        } else {
          account.setProperties(a);
        }
      } else if(!a['destroyed?']) {
        this.arr.addObject(Account.create(a));
      }
    });
  }
});

export default channel;
