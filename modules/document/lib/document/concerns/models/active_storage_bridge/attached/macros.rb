# frozen_string_literal: true

module Document
  module Concerns
    module Models
      module ActiveStorageBridge
        # Provides the class-level DSL for declaring that an Active Entity model has attached blobs.
        module Attached
          module Macros
            extend ActiveSupport::Concern

            module ClassMethods

              # def has_one_attached(name)
              #   class_eval <<-CODE, __FILE__, __LINE__ + 1
              #     def #{name}=(attachable)
              #       blob =
              #         case attachable
              #           when ActiveStorage::Blob
              #             attachable
              #           when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
              #             Document::Attachment.create file: attachable
              #           when Hash
              #             if attachable.keys.uniq.sort == ["filename", "type", "name", "tempfile", "head"].sort
              #               file= ActionDispatch::Http::UploadedFile.new(attachable)
              #               if file.tempfile.closed?
              #                 att = __method__.to_s.gsub "=", ""
              #                 Document::Attachment.find(send(att))
              #               else
              #                 Document::Attachment.create file: file
              #               end
              #             end
              #           when Integer
              #             Document::Attachment.find_by(id: attachable)
              #           when String
              #             Document::Attachment.find_by(id: attachable.to_i)
              #           else
              #             nil
              #         end
              #       super(blob&.id)
              #     end
              #   CODE
              # end

              def has_one_attached(name)
                class_eval do
                  class << self
                    alias_method :before_save, :before_validation
                    alias_method :after_commit, :after_validation
                    alias_method :after_save, :after_validation
                  end
                end

                attribute "#{name}_data", :string
                serialize"#{name}_data", JSON
                unless included_modules.include?(Support::Uploadable::Models::Concerns::ActsAsUploadable)
                  include Support::Uploadable::Models::Concerns::ActsAsUploadable
                end
                acts_as_uploadable name, metadata: false, ranked: false, processing_state: false, belongs_to_owner: false

                class_eval <<-CODE, __FILE__, __LINE__ + 1
                  def #{name}=(attachable)
                    blob =
                      case attachable
                        when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
                          attachable.tempfile.open if attachable.tempfile.closed?
                          attachable
                        when Hash
                          if attachable.keys.uniq.sort == ["filename", "type", "name", "tempfile", "head"].sort
                            attachable= ActionDispatch::Http::UploadedFile.new(attachable)
                            if attachable.tempfile.closed?
                              attachable.open
                             end
                          end
                          attachable
                      end
                    super(blob)
                  end
                CODE
              end

              def has_many_attached(name)
                class_eval <<-CODE, __FILE__, __LINE__ + 1
                  def #{name}=(attachables)
                    blobs = []
                    ids = []
                    attachables.flatten.collect do |attachable|
                      case attachable
                      when ActiveStorage::Blob
                        blobs << attachable
                      when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
                        blobs << Document::Attachment.create(file: attachable)
                      when Hash
                        if attachable.keys.uniq.sort == ["filename", "type", "name", "tempfile", "head"].sort
                          file= ActionDispatch::Http::UploadedFile.new(attachable)
                          if file.tempfile.closed?
                            att = __method__.to_s.gsub "=", ""
                            blobs << Document::Attachment.find_by_id(send(att))
                          else
                            blobs << Document::Attachment.create(file: file)
                          end
                        end
                      when Integer
                        ids << Document::Attachment.find_by(id: attachable).try(:id)
                      when String
                        ids << Document::Attachment.find_by(id: attachable.to_i).try(:id)
                      else
                        nil
                      end
                    end
                    super blobs.map(&:id).concat(Document::Attachment.where(id: ids.compact).pluck(:id))
                  end
                CODE
              end

            end
          end
        end
      end
    end
  end
end
