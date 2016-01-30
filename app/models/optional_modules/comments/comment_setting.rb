# == Schema Information
#
# Table name: comment_settings
#
#  id            :integer          not null, primary key
#  should_signal :boolean          default(TRUE)
#  send_email    :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

#
# == CommentSetting Model
#
class CommentSetting < ActiveRecord::Base
end