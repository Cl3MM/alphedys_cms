class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.string :role, :default => "user"

      t.string :firstname, :string
      t.string :lastname, :string
      t.string :company, :string
      t.string :phone, :string
      t.string :cellphone, :string
      t.string :fax, :string
      t.string :street, :string
      t.string :zip, :string
      t.string :city, :string

      t.timestamps
    end
  end
end
