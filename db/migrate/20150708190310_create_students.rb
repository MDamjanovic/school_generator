class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :gender
      t.boolean :with_special_needs
      t.references :school, index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
