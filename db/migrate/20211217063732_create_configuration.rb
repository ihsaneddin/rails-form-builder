class CreateConfiguration < ActiveRecord::Migration[6.1]
  def change
    create_table :configurations do |t|
      t.text :data
      t.string :name
      t.string :type
      t.references :context, polymorphic: true
      t.references :configurable, polymorphic: true
      t.timestamps
    end
  end
end
