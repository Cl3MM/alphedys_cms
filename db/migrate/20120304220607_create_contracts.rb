class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :user_id
      t.string :name
      t.float :price
      t.string :startdate
      t.string :endate

      t.timestamps
    end
    add_index :contracts, :user_id
  end
end
