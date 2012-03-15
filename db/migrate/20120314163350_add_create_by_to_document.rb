class AddCreateByToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :create_by, :integer
  end
end
