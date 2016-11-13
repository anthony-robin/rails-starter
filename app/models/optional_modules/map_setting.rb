# frozen_string_literal: true

# == Schema Information
#
# Table name: map_settings
#
#  id           :integer          not null, primary key
#  marker_icon  :string(255)
#  marker_color :string(255)
#  show_map     :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

#
# == MapSetting Model
#
class MapSetting < ActiveRecord::Base
  include MaxRowable
  include OptionalModules::Locationable

  def self.allowed_markers
    %w(camera building park car bus college gift)
  end

  validates :marker_icon,
            presence: false,
            allow_blank: true,
            inclusion: { in: allowed_markers }

  def marker_color?
    marker_color.present?
  end
end
