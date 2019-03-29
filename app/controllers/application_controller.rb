class ApplicationController < ActionController::Base
  def login
    @login ||= params[:login]
  end
  helper_method :login
end
