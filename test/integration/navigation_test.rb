require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  test "truth" do
    assert_kind_of Dummy::Application, Rails.application
  end
  
  test "pdf request sends a pdf as file" do
    visit home_path
    click_link 'PDF'
    
    assert_equal 'binary', headers['Content-Transfer-Encoding']
    assert_equal 'attachment; filename="contents.pdf"', headers['Content-Disposition']
    assert_equal 'application/pdf', headers['Content-Type']
  end
  
  protected
  
    def headers
      page.response_headers
    end
end