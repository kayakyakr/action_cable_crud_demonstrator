import Em from 'ember';

export default Em.Component.extend({
  tagName: 'tr',

  date: function(){
    return moment(this.get('expense.occurred_at')).local().format('YYYY-MM-DDTHH:mm:ss');
  }.property('expense.occurred_at'),

  actions: {
    updateDate: function(e){
      this.set('expense.occurred_at', moment($(e.target).val()).utc().toISOString());
    },

    destroy: function(){
      this.get('expense').destroy();
    }
  }
});
