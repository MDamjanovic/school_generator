class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :number
      t.references :school, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
