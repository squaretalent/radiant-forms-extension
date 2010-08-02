class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string    :title
      t.string    :action
      t.string    :redirect_to
      t.text      :body
      t.text      :output
      t.text      :config
    end
  end
  
  def self.down
    drop_table :forms
  end
end