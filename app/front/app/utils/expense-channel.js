import cable from './cable';
import Expense from 'front/models/expense';

var resolve, promise = new Promise((r) => { resolve = r; });
var channel = cable.subscriptions.create('ExpensesChannel', {
  list: function(arr){
    if(arr){ this.arr = arr; }
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

    data.forEach((e) => {
      let expense = this.arr.findBy('id', e.id);
      if(!expense){ expense = this.arr.findBy('id', null); }
      if(expense){
        if(e['destroyed?']){
          this.arr.removeObject(expense);
        } else if(expense.get('version') < e.version) {
          expense.setProperties(e);
        }
      } else if(!e['destroyed?']) {
        this.arr.addObject(Expense.create(e));
      }
    });
  }
});

export default channel;
