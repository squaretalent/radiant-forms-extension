class CreateUserObserver < ActiveRecord::Migration
  def self.up
    add_column :forms, :created_by, :integer
    add_column :forms, :updated_by, :integer
    add_column :forms, :created_at, :datetime
    add_column :forms, :updated_at, :datetime
  end
  
  def self.down
    remove_column :forms, :created_by
    remove_column :forms, :updated_by
    remove_column :forms, :created_at
    remove_column :forms, :updated_at
  end
end