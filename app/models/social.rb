# == Schema Information
#
# Table name: socials
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  link              :string(255)
#  kind              :string(255)
#  enabled           :boolean          default(TRUE)
#  ikon_updated_at   :datetime
#  ikon_file_size    :integer
#  ikon_content_type :string(255)
#  ikon_file_name    :string(255)
#  retina_dimensions :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

#
# == Social Model
#
class Social < ActiveRecord::Base
end
