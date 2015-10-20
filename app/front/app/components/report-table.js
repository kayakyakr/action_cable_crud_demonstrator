import Em from 'ember';

export default Em.Component.extend({
  reports: function(){
    var reports = [],
        attach_report = (user, account, expense) => {
          let report = reports.filterBy('user', user).filterBy('account', account).findBy('week', moment(Em.get(expense, 'occurred_at')).local().format('YY-ww'));
          if(report){
            Em.set(report, 'total', (parseFloat(Em.get(report, 'total')) + parseFloat(Em.get(expense, 'amount'))).toFixed(2));
            Em.set(report, 'average', (Em.get(report, 'total')/7.0).toFixed(2));
          } else {
            reports.addObject({user, account, week: moment(Em.get(expense, 'occurred_at')).local().format('YY-ww'),
                               total: parseFloat(Em.get(expense, 'amount')), average: (parseFloat(Em.get(expense, 'amount'))/7.0).toFixed(2)})
          }
        };

    this.get('allExpenses').forEach((e) =>{
      let account = this.get('allAccounts').findBy('id', Em.get(e, 'account_id'));
      if(!account){ return; }
      let user = this.get('allUsers').findBy('id', Em.get(account, 'user_id'));
      if(!user){ return; }

      attach_report(user, null, e);
      attach_report(user, account, e);
    });

    return reports;
  }.property('allUsers.[]', 'allAccounts.[]', 'allExpenses.@each.amount', 'allExpenses.@each.occurred_at', 'allExpenses.@each.account_id')
});
