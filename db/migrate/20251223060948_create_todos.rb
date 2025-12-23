class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :description
      t.boolean :completed, default: false, null: false
      t.integer :position

      t.timestamps
    end

    add_index :todos, :position
  end
end
