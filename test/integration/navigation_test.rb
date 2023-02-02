require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  test 'dummy application' do
    assert_kind_of Dummy::Application, Rails.application
  end

  test 'pdf request sends a pdf as file' do
    visit home_path
    click_link 'index'

    assert_equal 'binary', headers['Content-Transfer-Encoding']
    assert_equal "attachment; filename=\"contents.pdf\"; filename*=UTF-8''contents.pdf", headers['Content-Disposition']
    assert_equal 'application/pdf', headers['Content-Type']
  end

  test 'pdf request to an action with view template inside pdf subdirectory' do
    visit home_path
    click_link 'subdir_template'

    assert_equal 'binary', headers['Content-Transfer-Encoding']
    assert_equal "attachment; filename=\"subdir_template.pdf\"; filename*=UTF-8''subdir_template.pdf", headers['Content-Disposition']
    assert_equal 'application/pdf', headers['Content-Type']
  end

  protected

  def headers
    page.response_headers
  end
end
