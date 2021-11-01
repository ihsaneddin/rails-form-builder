class CreateDocumentTables < ActiveRecord::Migration[6.1]
  def change

    create_table :document_forms do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :type, null: false, index: true
      t.string :code
      t.belongs_to :documentable, polymorphic: true, index: true
      t.references :attachable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :document_fields do |t|
      t.string :name, null: false
      t.string :label, default: ""
      t.string :hint, default: ""
      t.integer :accessibility, null: false
      t.text :options
      t.text :validations
      t.integer :position
      t.string :type
      t.belongs_to :form, index: true
      t.belongs_to :section, index: true
      t.belongs_to :field_group, index: true
      t.timestamps
    end

    create_table :document_sections do |t|
      t.string :title, default: ""
      t.text :description
      t.boolean :headless, null: false, default: false
      t.belongs_to :form
      t.integer :position

      t.timestamps
    end

    create_table :document_field_groups do |t|
      t.string :name, default: ""

      t.timestamps
    end

  end
end