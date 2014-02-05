require 'rspec'
require 'yaml'
require 'pry'
require 'adyen'

adyen_config = YAML::load_file(File.dirname(__FILE__) + '/../config.yml')

Adyen.configuration.api_username = adyen_config['user']
Adyen.configuration.api_password = adyen_config['password']

Adyen.configuration.default_api_params[:merchant_account] = adyen_config['account']

describe 'Adyen' do
  it 'can authorize a payment' do
    invoice = double(id: 1, amount: 100)
    user = double(id: 1, email: 'test@example.com')
    response = Adyen::API.authorise_payment(
      invoice.id,
      { :currency => 'GBP', :value => invoice.amount },
      { :reference => user.id, :email => user.email, :ip => '8.8.8.8', :statement => 'invoice number 123456'},
      { :holder_name => "Simon Hopper", :number => '4111111111111111', :cvc => '737',
        :expiry_month => 6, :expiry_year => 2016 }
    )

    expect(response.authorized?).to be_true
  end
end