# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  username               :string(255)
#  slug                   :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  role_id                :integer          default(3), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  avatar_file_name       :string(255)
#  retina_dimensions      :text(65535)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  provider               :string(255)
#  uid                    :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_slug                  (slug)
#

#
# == User Model
#
class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]

  include Attachable

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :posts, dependent: :destroy
  has_many :blogs, dependent: :destroy
  belongs_to :role
  accepts_nested_attributes_for :role, reject_if: :all_blank

  delegate :name, to: :role, prefix: true, allow_nil: true

  retina!
  handle_attachment :avatar,
                    styles: {
                      large:  '512x512#',
                      medium: '256x256#',
                      small:  '128x128#',
                      thumb:  '64x64#'
                    }

  validates_attachment :avatar,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { less_than: 2.megabyte }

  include DeletableAttachment

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false,
              scope: :provider
            }
  validates :email,
            presence: { message: 'Ne doit pas être vide' },
            email_format: true,
            uniqueness: {
              case_sensitive: false,
              scope: :provider
            }

  scope :except_super_administrator, -> { where.not(role_id: 1) }

  def super_administrator?
    role_name == 'super_administrator'
  end

  def administrator?
    role_name == 'administrator'
  end

  def subscriber?
    role_name == 'subscriber'
  end

  def should_generate_new_friendly_id?
    username_changed? || super
  end

  def avatar?
    avatar.present? && avatar.exists?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.username = auth.info.name
      user.username = "#{auth.info.name} #{auth.info.uid}" if User.exists?(username: auth.info.name)
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar = URI.parse(process_uri(auth.info.image)) if auth.info.image?
    end
  end

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, allow_redirections: :safe) do |r|
      r.base_uri.to_s
    end
  end

  def from_omniauth?
    !(provider.blank? && uid.blank?)
  end
end
