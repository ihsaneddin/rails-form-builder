require 'support/configuration'
require 'support/uploadable/models/concerns/uploadable'
require 'support/uploadable/models/concerns/acts_as_uploadable'
require 'support/uploadable/models/concerns/is_uploadable'
require 'support/optionable/models/concerns/optionable'

require "support/version"
require "support/engine"

module Support
  extend Support::Configuration
end

require 'support/hooks'