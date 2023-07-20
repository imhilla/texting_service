class RemoveColumnsFromMessages < ActiveRecord::Migration[7.0]
  def change
    remove_index :messages, :provider_id
    remove_column :messages, :provider_id, :integer
  end
end
