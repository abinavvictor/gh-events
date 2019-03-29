require 'octokit'

class EventsController < ApplicationController

  def index
    return unless login

    redirect_to "/events/#{login}"
  end

  def list
    @user = user_for(params[:login])
    @events = events_for(@user)
  end

  private

  def login
    params[:login]
  end

  def client
    @client ||= Octokit::Client.new
  end

  def events_for(user)
    return [] unless user

    client.user_events(user.id)
  end

  def user_for(login)
    return unless login

    client.user(login)
  end
end
