class Campaign < ActiveRecord::Base
  has_attached_file :banner, :styles => { :medium => "200x200>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/
end
