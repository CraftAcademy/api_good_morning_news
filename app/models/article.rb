class Article < ApplicationRecord
  validates_presence_of :title, :teaser, :content, :category
  enum category: [:sports, :entertainment, :weather, :business, :news]
  belongs_to :journalist, class_name: "User"
end
