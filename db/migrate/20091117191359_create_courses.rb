class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.string :subject
      t.string :number
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end