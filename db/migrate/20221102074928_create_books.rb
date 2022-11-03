class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :genre
      t.string :author
      t.float :price
      t.text :summary
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
