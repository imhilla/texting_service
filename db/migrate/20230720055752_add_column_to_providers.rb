class AddColumnToProviders < ActiveRecord::Migration[7.0]
  def change
    add_column :providers, :url, :string
  end
end
