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

  desc '全員を退室'
  task leaveall: :environment do |_task, _args|
    puts 'starting leaveall task...'
    carepi_wallet = Glueby::Wallet.load(User.find(0).wallet_id)
    carepi_wallet.balances.each do |_bal|
      next if _bal[0].blank?

      color_id = _bal[0]
      amount = _bal[1]
      color_id_byte = Tapyrus::Color::ColorIdentifier.parse_from_payload(color_id.to_s.htb)
      token = Glueby::Contract::Token.new(color_id: color_id_byte)
      token.burn!(sender: carepi_wallet, amount:)
    end
    Glueby::Internal::RPC.client.generatetoaddress(1, carepi_wallet.internal_wallet.receive_address, ENV['AUTH_KEY'])
    system('rails glueby:block_syncer:start')
  end
end
