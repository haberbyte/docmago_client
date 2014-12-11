class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.pdf { render pdf: 'contents' }
    end
  end

  def subdir_template
    respond_to do |format|
      format.html
      format.pdf { render pdf: 'subdir_template' }
    end
  end
end
