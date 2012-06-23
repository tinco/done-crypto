class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :public_key
      t.timestamps
    end
  end
end
