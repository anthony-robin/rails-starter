require 'test_helper'

#
# == BlogsController Test
#
class BlogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Routes / Templates / Responses
  #
  test 'should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, locale: locale.to_s
        assert_response :success
        assert_not_nil assigns(:blogs)
      end
    end
  end

  test 'should use index template' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, locale: locale.to_s
        assert_template :index
      end
    end
  end

  test 'should get show page with all locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @blog
        assert_response :success
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @blog
        assert_equal request.path_parameters[:id], @blog.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
  end

  test 'should get index page targetting blogs controller' do
    assert_routing '/blog', controller: 'blogs', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/blog', controller: 'blogs', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Object
  #
  test 'should fetch only online posts' do
    @blogs = Blog.online
    assert_equal @blogs.length, 1
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @locales = I18n.available_locales
  end
end
