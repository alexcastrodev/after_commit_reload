require 'rack/test'
require 'test/unit'
require_relative '../lib/model'
require_relative '../lib/app'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    ActiveRecord::Base.connection.create_table :items do |t|
      t.string :name

      t.belongs_to :bundle, index: true, foreign_key: { to_table: :items }
    end
  end

  def teardown
    ActiveRecord::Base.connection.drop_table :items
  end

  def test_root_route
    # prepare
    post '/items', { name: "Lekito on Sinatra" }.to_json

    puts last_response.body

  end
end
