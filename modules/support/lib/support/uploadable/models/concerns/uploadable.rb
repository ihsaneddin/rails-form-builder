require 'ranked-model'

module Support
  module Uploadable
    module Models
      module Concerns
        module Uploadable
          extend ActiveSupport::Concern

          included do
            # include shrine functionality and set defaults
            include Support.uploadable.file_uploader_class.new(:file)

            before_validation do
              self.metadata= {} if respond_to?(:metadata) and metadata.nil?
            end

            after_initialize do
              self.metadata= {} if respond_to?(:metadata) and metadata.nil?
            end

            serialize :metadata, Hash

            # include ranking functionality
            include RankedModel
            ranks :order, with_same: [:uploadable_id, :uploadable_type]

            # associations
            belongs_to :uploadable, polymorphic: true, optional: true

            # validation
            if Support.uploadable.file_is_required
              validates :file, presence: true
            end

            # callbacks
            before_save :set_processing_state, :set_mime_type

            # scopes
            scope :ordered, -> { rank(:order) }

            # set class variables (can be overriden by uploadable_set)
            # attr_accessors are set in class_methods
            @processors = Support.uploadable.processors
            @whitelist = Support.uploadable.whitelist
            @max_file_size = Support.uploadable.max_file_size
          end

          class_methods do
            attr_accessor :processors, :whitelist, :max_file_size

            # set custom settings on per-model-basis
            # use after including module like:
            # include Supprt::Uploadable::Models::Concerns::Uploadable
            # uploadable_set processors: { image: "Processors::CustomImage" },
            #   whitelist: ["image/jpeg"],
            #   max_file_size: 5.megabytes
            def uploadable_set(options = {})
              self.processors = options[:processors] unless options[:processors].nil?
              self.whitelist = options[:whitelist] unless options[:whitelist].nil?
              self.max_file_size = options[:max_file_size] unless options[:max_file_size].nil?
            end
          end

          def processors
            _processors = self.class.processors
            if uploadable && uploadable.class.uploadable_processors
              _processors = uploadable.class.uploadable_processors
            end
            _processors
          end

          def whitelist
            _whitelist = self.class.whitelist
            if uploadable && uploadable.class.uploadable_whitelist
              _whitelist = uploadable.class.uploadable_whitelist
            end
            _whitelist
          end

          def max_file_size
            _max_file_size = self.class.max_file_size
            if uploadable && uploadable.class.uploadable_max_file_size
              _max_file_size = uploadable.class.uploadable_max_file_size
            end
            _max_file_size
          end

          def mime_type
            self.metadata['mime_type']
          end

          def type
            self.mime_type.split('/')[0] if self.mime_type
          end

          def has_versions?
            self.file.is_a?(Hash) ? true : false
          end

          # return file even if the upload has multiple versions
          # optionally a version can be specified
          def reluctant_file(version = nil)
            if self.has_versions? && version.blank?
              self.file[self.file.keys.first]
            elsif self.has_versions? && !version.blank?
              self.file[version].blank? ? self.file[self.file.keys.first] : self.file[version]
            else
              self.file
            end
          end

          def image?
            self.type == "image" ? true : false
          end

          def video?
            self.type == "video" ? true : false
          end

          private

            def set_processing_state
              if file_data_changed? && file_attacher.cached?
                self.processing = true
              elsif file_data_changed? && file_attacher.stored?
                self.processing = false
              end
            end

            # sync with mime-type of file or first version
            def set_mime_type
              self.metadata = {} if self.metadata.nil?
              self.metadata['mime_type'] = self.reluctant_file.mime_type
            end
        end
      end
    end
  end
end
