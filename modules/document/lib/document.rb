require_relative 'concern.rb'

require 'validates_timeliness'

require 'document/coder'
require 'document/coders/hash_coder'
require 'document/coders/yaml_coder'

require 'document/errors'
require 'document/concerns/models/active_storage_bridge/attached/macros'
require 'document/concerns/models/acts_as_default_value'
require 'document/concerns/models/enum_attribute_localizable'
require 'document/concerns/models/fields/helper'
require 'document/concerns/models/form'
require 'document/concerns/models/field'
require 'document/concerns/models/is_document'
require 'document/field_options'
require 'document/non_configurable_field'
require 'document/virtual_model'

require 'document/concerns/models/field'
require 'document/concerns/models/form'
%w[acceptance confirmation exclusion format inclusion length numericality presence file].each do |file|
  require "document/concerns/models/fields/validations/#{file}"
end

require 'document/patches/active_support/prependable'

require 'document/configuration'
require "document/version"
require "document/engine"

module Document
  # Your code goes here...
  extend Configuration

end
