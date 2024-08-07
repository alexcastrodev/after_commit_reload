require "sinatra"
require "json"
require_relative "./model"

on_start do
  ActiveRecord::Base.connection.create_table :items do |t|
    t.string :name

    t.belongs_to :bundle, index: true, foreign_key: { to_table: :items }
  end
end

on_stop do
  ActiveRecord::Base.connection.drop_table :users
  ActiveRecord::Base.connection.drop_table :roles
end


post '/items' do
  request.body.rewind
  @request_payload = JSON.parse request.body.read

  @item = Item.new(@request_payload)
  content_type :json

  if @item.save
    status 201

    { item: @item, bundle_items: @item.bundle_items }.to_json
  else
    status 400
    @item.errors.to_json
  end
end
