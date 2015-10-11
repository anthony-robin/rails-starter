ActiveAdmin.register VideoSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :video_platform,
                :video_upload

  decorate_with VideoSettingDecorator
  config.clear_sidebar_sections!

  show do
    columns do
      column do
        attributes_table do
          row :video_platform_d
          row :video_upload_d
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :video_platform,
                  hint: I18n.t('form.hint.video.video_platform')
          f.input :video_upload,
                  hint: I18n.t('form.hint.video.video_upload')
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @video_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_video_setting_path(VideoSetting.first), status: 301
    end
  end
end
