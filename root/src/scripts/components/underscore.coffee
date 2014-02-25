'use strict'

require '../bower_components/scripts/underscore/underscore'

# Ensure we're working with an unmodified version of underscore.
_ = window._.noConflict()

# Require any underscore extensions here; attaching as neccessary.
# Example:
#   _.mixin require('underscore-string').exports()

# Export the underscore library.
module.exports = _
