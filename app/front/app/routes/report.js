import Em from 'ember';

export default Em.Route.extend({
  model: function(){
    return this.modelFor('application');
  }
});
