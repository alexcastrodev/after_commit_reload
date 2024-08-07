require 'sinatra'
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

class Item < ActiveRecord::Base
  validates_presence_of :name
  after_commit :create_bundle_items

  belongs_to :bundle, class_name: "Item", optional: true

  def bundle_items
    Item.where(bundle_id: self.id)
  end

  private

  def create_bundle_items
    # Just figure out that the first item is always a bundle
    return unless self.id == 1
    # Create always 5 bundle items with random names
    5.times do |i|
      Item.create(name: "#{self.name}_#{i}", bundle_id: self.id)
    end
  end
end
