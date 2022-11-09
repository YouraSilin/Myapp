class CreatePhones < ActiveRecord::Migration[7.0]
  def change
    create_table :phones do |t|
      t.string :number
      t.string :name
      t.string :colour
      t.string :position
      t.string :department
      t.timestamps
    end
  end
end
