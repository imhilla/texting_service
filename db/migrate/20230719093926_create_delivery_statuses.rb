class CreateDeliveryStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_statuses do |t|
      t.string :status
      t.string :message_id

      t.timestamps
    end
  end
end
