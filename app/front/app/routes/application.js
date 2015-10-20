import Em from 'ember';
import user_channel from 'front/utils/user-channel';
import account_channel from 'front/utils/account-channel';
import expense_channel from 'front/utils/expense-channel';

export default Em.Route.extend({
  model: function(){
    let model = {users: [], accounts: [], expenses: []};
    Promise.all([
      new Promise((resolve) => ( user_channel.connected = () => resolve() )),
      new Promise((resolve) => ( account_channel.connected = () => resolve() )),
      new Promise((resolve) => ( expense_channel.connected = () => resolve() ))
    ]).then(() => {
      user_channel.list(Em.get(model, 'users'));
      account_channel.list(Em.get(model, 'accounts'));
      expense_channel.list(Em.get(model, 'expenses'));
    });

    return model;
  }
});
