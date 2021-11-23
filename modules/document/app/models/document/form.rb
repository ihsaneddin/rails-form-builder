module Document
  class Form < BareForm

    has_many :sections, -> { order(position: :asc) }, class_name: "Document::Section", dependent: :destroy, inverse_of: :form, index_errors: true
    accepts_nested_attributes_for :sections, allow_destroy: true

    has_many :rows, class_name: "Document::FormRow", foreign_key: :form_id

    alias_method :segments=, :sections_attributes=

    NAME_REGEX = /\A[a-z][a-z_0-9]*\z/.freeze

    validates :name,
              presence: true,
              uniqueness: { scope: [:documentable_id, :documentable_type] },
              exclusion: { in: Document.reserved_names },
              format: { with: NAME_REGEX }

    validates :title, presence: true
    validates :name, presence: true

    after_create :auto_create_default_section

    private

      def auto_create_default_section
        if sections.blank?
          sections.create! title: I18n.t("defaults.section.title"), headless: true
        end
      end

  end
end
