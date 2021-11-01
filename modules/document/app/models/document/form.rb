module Document
  class Form < BareForm

    has_many :sections, -> { order(position: :asc) }, class_name: "Document::Section", dependent: :destroy, inverse_of: :form, index_errors: true
    accepts_nested_attributes_for :sections, allow_destroy: true

    alias_method :segments=, :sections_attributes=

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
