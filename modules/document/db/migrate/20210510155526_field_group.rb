class FieldGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :document_field_groups do |t|
      t.string :name default: ""
      t.timestamps
    end
  end
end
