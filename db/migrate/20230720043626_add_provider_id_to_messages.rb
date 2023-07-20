class AddProviderIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :provider, null: false, foreign_key: true
  end
end
