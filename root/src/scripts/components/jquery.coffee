'use strict'

require '../bower_components/scripts/jquery/jquery'

# Ensure we're working with an unmodified version of jQuery.
jQuery = window.jQuery.noConflict()

# Require any jQuery extensions here; attaching as neccessary.
# Example:
#   require 'bootstrap'

# Export the jQuery library.
module.exports = jQuery
