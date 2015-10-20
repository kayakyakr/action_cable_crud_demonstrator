import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('expenses', {path: '/'});
  this.route('user', {path: '/user/:id'});
  this.route('account.new', {path: '/user/:user_id/account/new'});
  this.route('account.edit', {path: '/account/:id'});
  this.route('report');
});

export default Router;
