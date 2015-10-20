import Em from 'ember';

export default Em.Component.extend({
  classNames: ['btn'],
  classNameBindings: ['btnClass'],

  btnClass: 'btn-primary',

  click: function(){
    let success = Em.run.bind(this.get('target'), this.get('action'))();
    if(success !== false){
      this.get('router').transitionTo(this.get('transition') || 'expenses');
    }
  }
});
