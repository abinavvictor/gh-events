class HomeController < ApplicationController
  def index
    return unless login

    redirect_to "/events/#{login}"
  end

end