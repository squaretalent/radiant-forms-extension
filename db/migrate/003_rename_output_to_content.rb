class RenameOutputToContent < ActiveRecord::Migration
  def self.up
    rename_column :forms, :output, :content
  end
  
  def self.down
    rename_column :forms, :content, :output
  end
end