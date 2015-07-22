# == Schema Information
#
# Table name: slides
#
#  id                 :integer          not null, primary key
#  attachable_id      :integer
#  attachable_type    :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  title              :string(255)
#  description        :text(65535)
#  retina_dimensions  :text(65535)
#  primary            :boolean          default(FALSE)
#  online             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_slides_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#

#
# == Slide Model
#
class Slide < ActiveRecord::Base
  include Attachable

  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  belongs_to :attachable, polymorphic: true

  retina!
  has_attachment :image,
                 styles: {
                  slide: '2000x',
                  preview: '1500x'
                }

  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

  scope :online, -> { where(online: true) }

  def slide?
    image.exists?
  end
end
