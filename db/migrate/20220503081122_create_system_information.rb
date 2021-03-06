class CreateSystemInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :glueby_system_informations do |t|
      t.string  :info_key
      t.string  :info_value
      t.timestamps
    end
    add_index  :glueby_system_informations, [:info_key], unique: true

    Glueby::AR::SystemInformation.create(info_key: "synced_block_number", info_value: "0")
  end
end