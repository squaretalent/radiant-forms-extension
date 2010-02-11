class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string :title, :action, :redirect_to
      t.text :body, :output, :config
    end
    
  end
  
  def self.down
    drop_table :forms
  end
end