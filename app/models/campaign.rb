class Campaign < ActiveRecord::Base
  has_attached_file :banner, :styles => { :medium => "200x200 #" }, :default_url => "/images/banner/banner.jpg"
  validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/

  validates :name, :url, presence: true

  def image_url
    banner.url(:medium)
  end
end
