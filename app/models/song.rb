class Song < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre

  def to_slug
    self.name.split(" ").join("-").downcase
  end
end
