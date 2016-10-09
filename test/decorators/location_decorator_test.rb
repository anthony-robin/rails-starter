# frozen_string_literal: true
require 'test_helper'

#
# == LocationDecorator test
#
class LocationDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct address inline' do
    assert_equal '<span>1 Main Street, 06001 - Auckland</span>', @location.full_address
  end

  test 'should return true as boolean for latlon?' do
    assert @location.latlon?
  end

  test 'should return true as boolean for city?' do
    assert @location.city?
  end

  test 'should return true as boolean for postcode?' do
    assert @location.city?
  end

  test 'should return false as boolean for latlon?' do
    location = LocationDecorator.new(@location_two)
    assert_not location.latlon?
  end

  private

  def initialize_test
    @location_one = locations(:one)
    @location_two = locations(:two)
    @location = LocationDecorator.new(@location_one)
  end
end
