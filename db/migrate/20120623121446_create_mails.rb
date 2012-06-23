class CreateMails < ActiveRecord::Migration
  def change
    create_table :mails do |t|
      t.references :user
      t.text :body
      t.timestamps
    end
  end
end
