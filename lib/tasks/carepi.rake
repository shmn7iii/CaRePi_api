namespace :carepi do
  desc '初期処理'
  task init: :environment do |_task, _args|
    wallet = Glueby::Wallet.create
    puts "create wallet: #{wallet.id}"

    address = wallet.internal_wallet.receive_address
    puts "address: #{address}"

    carepi = User.create do |u|
      u.id = 0
      u.wallet_id = wallet.id
    end

    Glueby::Internal::RPC.client.generatetoaddress(1, address, ENV['AUTH_KEY'])
    `rails glueby:contract:block_syncer:start`
  end
end
