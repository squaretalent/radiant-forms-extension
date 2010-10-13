class AddAnotherContentField < ActiveRecord::Migration
  def self.up
    add_column :forms, :secondary, :text
  end

  def self.down
    remove_column :forms, :secondary
  end
end
