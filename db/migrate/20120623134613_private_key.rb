class PrivateKey < ActiveRecord::Migration
  def up
    add_column :users, :private_key, :string
  end

  def down
    remove_column :users, :private_key
  end
end
