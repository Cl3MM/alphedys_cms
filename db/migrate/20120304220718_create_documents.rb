class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :contract_id

      t.timestamps
    end
    add_index :documents, :contract_id
  end
end
