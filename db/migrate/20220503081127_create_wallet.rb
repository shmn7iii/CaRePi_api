class CreateWallet < ActiveRecord::Migration[6.1]
  def change
    create_table :glueby_wallets do |t|
      t.string :wallet_id
      t.timestamps
    end

    add_index :glueby_wallets, [:wallet_id], unique: true
  end
end
