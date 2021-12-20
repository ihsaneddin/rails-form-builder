class Configuration < ApplicationRecord

  # serialize :data

  validates :name, presence: true
  belongs_to :context, optional: true, polymorphic: true
  belongs_to :configurable, optional: true, polymorphic: true

end
