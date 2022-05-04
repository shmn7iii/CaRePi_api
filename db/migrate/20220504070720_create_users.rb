class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :wallet_id
      t.string :color_id

      t.timestamps
    end
  end
end
