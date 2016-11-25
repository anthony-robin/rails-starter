# frozen_string_literal: true

#
# == AdultSetting
#
puts 'Creating AdultSetting'
adult_setting = AdultSetting.create!(
  enabled: true,
  title: 'Bienvenue sur le site de démonstration',
  content: set_content(paragraph: 1),
  redirect_link: Figaro.env.adult_not_validated_popup_redirect_link
)

if @locales.include?(:en)
  AdultSetting::Translation.create!(
    adult_setting_id: adult_setting.id,
    locale: 'en',
    title: 'Welcome to the demonstration website',
    content: set_content(paragraph: 1)
  )
end
