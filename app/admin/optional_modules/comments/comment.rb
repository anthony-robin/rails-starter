# frozen_string_literal: true
ActiveAdmin.register Comment, as: 'PostComment' do
  menu parent: I18n.t('admin_menu.modules')
  includes :user

  permit_params :id,
                :username,
                :email,
                :comment,
                :user_id,
                :role,
                :validated,
                :signalled

  scope I18n.t('scope.all'), :all, default: true, if: proc { current_user_and_administrator? }
  scope I18n.t('active_admin.globalize.language.fr'), :french, if: proc { @locales.length > 1 && current_user_and_administrator? }
  scope I18n.t('active_admin.globalize.language.en'), :english, if: proc { @locales.length > 1 && current_user_and_administrator? }
  scope I18n.t('comment.to_validate.scope'), :to_validate, if: proc { @comment_setting.should_validate? && current_user_and_administrator? }
  scope I18n.t('comment.signalled.scope'), :signalled, if: proc { @comment_setting.should_signal? && current_user_and_administrator? }

  decorate_with CommentDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new]

  batch_action :toggle_validated, if: proc { can? :toggle_validated, Comment } do |ids|
    Comment.find(ids).each do |comment|
      comment.toggle! :validated
      email_comment_validated(comment) if comment.validated?
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  batch_action :toggle_signalled, if: proc { can? :toggle_signalled, Comment } do |ids|
    Comment.find(ids).each { |item| item.toggle! :signalled }
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :author_with_avatar
    column :email_registered_or_guest
    column :lang if locales.length > 1
    bool_column :validated
    bool_column :signalled if comment_setting.should_signal?
    column :link_and_image_source
    column :created_at

    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      attributes_table do
        row :author_with_avatar
        row :email_registered_or_guest
        row :content
        row :lang if locales.length > 1
        bool_row :validated
        bool_row :signalled if comment_setting.should_signal?
        row :link_and_image_source
        row :created_at
      end
    end
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    before_action :set_comment_setting, only: [:index, :show]

    def scoped_collection
      super.includes user: [:role]
    end

    private

    def set_comment_setting
      @locales = I18n.available_locales
      @comment_setting = CommentSetting.first
    end

    def email_comment_validated(comment)
      CommentValidatedJob.set(wait: 3.seconds).perform_later(comment)
    end
  end
end
