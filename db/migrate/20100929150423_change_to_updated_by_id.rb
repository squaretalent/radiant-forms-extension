class ChangeToUpdatedById < ActiveRecord::Migration
  def self.up
    add_column :forms,    :created_by_id,   :integer
    add_column :forms,    :updated_by_id,   :integer
    remove_column :forms, :created_by
    remove_column :forms, :updated_by
  end

  def self.down
    remove_column :forms, :created_by_id
    remove_column :forms, :updated_by_id
    add_column :forms,    :created_by,      :integer
    add_column :forms,    :updated_by,      :integer
  end
end
