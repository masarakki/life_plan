class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :provider, :null => false
      t.string :uid,      :null => false
      t.string :name,     :null => false
      t.timestamps
    end

    add_index :users, [:provider, :uid], :unique => true
  end
end
