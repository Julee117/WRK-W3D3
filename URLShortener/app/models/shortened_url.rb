# == Schema Information
#
# Table name: shortened_urls
#
#  id        :integer          not null, primary key
#  short_url :string           not null
#  long_url  :string           not null
#  user_id   :integer          not null
#

require 'securerandom'
require 'byebug'
class ShortenedUrl < ApplicationRecord
  include SecureRandom

    belongs_to :user,
      class_name: :User,
      foreign_key: :user_id,
      primary_key: :id

    has_many :visits,
      class_name: :Visit,
      foreign_key: :shortened_url_id,
      primary_key: :id

    has_many :visitors,
    Proc.new { distinct }
      through: :visits,
      source: :user

    def self.random_code
      random_code = SecureRandom.urlsafe_base64

      until !ShortenedUrl.exists?(short_url: random_code)
        random_code = SecureRandom.urlsafe_base64
      end
      random_code
    end

    def self.create_short_url(user, long_url)
      ShortenedUrl.create(user_id: user.id, long_url: long_url,
        short_url: ShortenedUrl.random_code)
    end

    def num_clicks
      self.visits.count
    end

    def num_uniques
      self.visits.select(:user_id).distinct.count
    end

    def num_recent_uniques
      self.visits.select { |visit| Time.now.utc.min - visit.created_at.min < 10 }
    end
end
