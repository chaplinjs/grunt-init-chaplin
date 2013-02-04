'use strict';

require('depend!../components/scripts/backbone/backbone[jquery,underscore]');

// Ensure we're working with an unmodified version of Backbone.
var Backbone = window.Backbone.noConflict();

// Require any backbone extensions here; attaching as neccessary.
// Example:
//   require 'backbone-stickit'

// Export the backbone library.
module.exports = Backbone;
