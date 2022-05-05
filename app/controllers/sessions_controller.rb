class SessionsController < ApplicationController
  before_action :load_carepi_wallet

  def new
    student_number = params[:student_number].to_i

    if student_number.nil?
      response_bad_request('Student Number is required')
      return
    end

    if user = User.find_by(id: student_number)
      @wallet_id = user.wallet_id
      @wallet = Glueby::Wallet.load(@wallet_id)
      @color_id = user.color_id
    else
      @wallet = Glueby::Wallet.create
      @wallet_id = @wallet.id

      begin
        tokens = Glueby::Contract::Token.issue!(issuer: @wallet, amount: 1)
        generate(@carepi_wallet.internal_wallet.receive_address)
      rescue Glueby::Contract::Errors::InsufficientFunds
        pay2user(@wallet_id)
        retry
      end
      @color_id = 'c1' + tokens[0].color_id.payload.bth
      user = User.create do |u|
        u.id = student_number
        u.wallet_id = @wallet_id
        u.color_id = @color_id
      end
    end

    slack_message = ''
    color_id_byte = Tapyrus::Color::ColorIdentifier.parse_from_payload(@color_id.to_s.htb)
    token = Glueby::Contract::Token.new(color_id: color_id_byte)

    if @carepi_wallet.balances.include?(@color_id)
      # burn token
      begin
        tx = token.burn!(sender: @carepi_wallet, amount: 1)
        generate(@carepi_wallet.internal_wallet.receive_address)
      rescue Glueby::Contract::Errors::InsufficientFunds
        pay2user(@wallet_id)
        retry
      end
      slack_message = "#{student_number} が退室しました"
    else
      # reissue token
      begin
        (color_id_result, tx) = token.reissue!(issuer: @wallet, amount: 1)
        generate(@carepi_wallet.internal_wallet.receive_address)
      rescue Glueby::Contract::Errors::InsufficientFunds
        pay2user(@wallet_id)
        retry
      end

      # transfer token
      begin
        (color_id_result, tx) = token.transfer!(sender: @wallet,
                                                receiver_address: @carepi_wallet.internal_wallet.receive_address,
                                                amount: 1)
        generate(@carepi_wallet.internal_wallet.receive_address)
      rescue Glueby::Contract::Errors::InsufficientFunds
        pay2user(@wallet_id)
        retry
      end
      slack_message = "#{student_number} が入室しました"
    end

    # send message to slack
    send_message_to_slack(slack_message) if params[:send_slack]

    # return status_code
    response_success('session', 'new', slack_message)
  end

  private

  def load_carepi_wallet
    @carepi_wallet = Glueby::Wallet.load(User.find(0).wallet_id)
  end

  def pay2user(_wallet_id)
    wallet = Glueby::Wallet.load(_wallet_id)
    receive_address = wallet.internal_wallet.receive_address
    generate(receive_address)
  end

  def generate(_address)
    Glueby::Internal::RPC.client.generatetoaddress(1, _address, ENV['AUTH_KEY'])
    system('rails glueby:block_syncer:start')
  end

  def send_message_to_slack(_message)
    response = HTTP.post('https://slack.com/api/chat.postMessage', params: {
                           token: ENV['SLACK_API_TOKEN'],
                           channel: ENV['SLACK_CHANNEL'],
                           text: _message,
                           as_user: true
                         })
  end
end
