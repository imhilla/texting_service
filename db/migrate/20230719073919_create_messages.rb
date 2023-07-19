class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :to_number
      t.string :message
      t.string :message_id
      t.string :status

      t.timestamps
    end
  end
end
