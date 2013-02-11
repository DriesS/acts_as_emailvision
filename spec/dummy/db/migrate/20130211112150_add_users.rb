class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :email, :first_name, :last_name, :city
      t.boolean :wants_email, :confirmed
    end
  end
end
