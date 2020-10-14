# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  enum roles: [:user, :journalist]
  has_many :articles, foreign_key: "journalist_id", class_name: "Article"
end
