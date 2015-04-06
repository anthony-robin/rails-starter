#
# == Category Model
#
class Category < ActiveRecord::Base
  translates :title
  active_admin_translates :title

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true

  scope :visible_header, -> { where(show_in_menu: true) }
  scope :visible_footer, -> { where(show_in_footer: true) }

  def self.models_name
    [:Home, :About, :Contact]
  end

  def self.models_name_str
    %w( Home About Contact )
  end
end
