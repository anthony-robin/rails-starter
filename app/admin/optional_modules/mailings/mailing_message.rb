ActiveAdmin.register MailingMessage do
  menu parent: I18n.t('admin_menu.modules')

  permit_params :id,
                :token,
                :sent_at,
                mailing_user_ids: [],
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  decorate_with MailingMessageDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :title
    column :preview
    column :status
    column :sent_at
    column :send_link

    actions
  end

  show do
    panel t('active_admin.details', model: active_admin_config.resource_label) do
      attributes_table_for resource.decorate do
        row :status
        row :sent_at
        row :preview
        row :live_preview
        row :send_link
      end
    end
  end

  form do |f|
    render 'admin/mailings/form', f: f
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include Mailingable
    include NewsletterHelper

    def send_mailing_message
      @mailing_message.update_attributes(sent_at: Time.zone.now)
      @mailing_users = @mailing_message.mailing_users
      make_mailing_message_with_i18n(@mailing_message, @mailing_users)

      flash[:notice] = I18n.t('mailing.notice_sending', count: @mailing_users.count)
      make_redirect
    end

    def preview
      @title = @mailing_message.title
      @content = @mailing_message.content
      @mailing_user = MailingUser.new(id: 1, email: 'test@test.fr', fullname: 'Testeur', token: '1234567-AZ')
      render 'mailing_message_mailer/send_email', layout: 'mailing'
    end

    private

    def make_mailing_message_with_i18n(message, mailing_users)
      mailing_users.each do |user|
        MailingMessageJob.set(wait: 3.seconds).perform_later(user, message)
      end
    end

    def make_redirect
      redirect_to :back
    end
  end
end
