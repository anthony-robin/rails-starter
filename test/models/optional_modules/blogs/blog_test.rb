# frozen_string_literal: true
require 'test_helper'

#
# == Blog model test
#
class BlogTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Validation rules
  #
  test 'should not be valid if no category specified' do
    blog = Blog.new
    refute blog.valid?, 'should not be valid if all fields are blank'
    assert_equal [:blog_category], blog.errors.keys
  end

  test 'should not be valid if category doesn\'t exist' do
    attrs = { blog_category_id: 999 }
    blog = Blog.new attrs
    refute blog.valid?, 'should not be valid if category doesn\'t exist'
    assert_equal [:blog_category], blog.errors.keys
  end

  test 'should be valid if category exists' do
    attrs = { blog_category_id: @blog_category.id }
    blog = Blog.new attrs
    assert blog.valid?, 'should be valid if category exists'
    assert_empty blog.errors.keys
  end

  test 'should increase counter cache' do
    reset_counter_cache
    attrs = { blog_category_id: @blog_category.id }
    blog = Blog.new attrs
    blog.save
    @blog_category.reload

    assert_equal 3, @blog_category.blogs.size
  end

  test 'should decrease counter cache' do
    reset_counter_cache
    blog = Blog.new(blog_category_id: @blog_category.id)
    blog_2 = Blog.new(blog_category_id: @blog_category.id)
    blog.save
    blog_2.save
    @blog_category.reload
    assert_equal 4, @blog_category.blogs.size

    blog.destroy
    @blog_category.reload
    assert_equal 3, @blog_category.blogs.size
  end

  #
  # == Count
  #
  test 'should return correct count for blogs posts' do
    assert_equal 3, Blog.count
  end

  test 'should fetch only online blog posts' do
    assert_equal 2, Blog.online.count
  end

  #
  # == Prev / Next
  #
  test 'should have a next record' do
    assert @blog.next?, 'should have a next record'
  end

  test 'should have a prev record' do
    assert @blog_third.prev?, 'should have a prev record'
  end

  test 'should not have a prev record' do
    assert_not @blog.prev?, 'should not have a prev record'
  end

  test 'should not have a next record' do
    assert_not @blog_third.next?, 'should not have a next record'
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no video are uploaded' do
    @blog.save!
    assert @blog.valid?, 'should be valid'
    assert_empty @blog.errors.keys
    assert @blog.flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @blog.update_attributes(video_uploads_attributes: [{ video_file: video }, { video_file: video }])
    @blog.save!
    assert @blog.valid?, 'should be valid'
    assert_empty @blog.errors.keys
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @blog.flash_notice
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @blog_third = blogs(:blog_third)

    @blog_category = blog_categories(:one)
    @blog_category_2 = blog_categories(:two)
  end

  def reset_counter_cache
    BlogCategory.reset_column_information
    BlogCategory.all.each do |p|
      BlogCategory.update_counters p.id, blogs_count: p.blogs.length
    end

    @blog_category.reload
    @blog_category_2.reload
    assert_equal 2, @blog_category.blogs.size
    assert_equal 1, @blog_category_2.blogs.size
  end
end
