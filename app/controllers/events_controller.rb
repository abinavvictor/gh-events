require 'octokit'

class EventsController < ApplicationController

  def home
    return unless login

    redirect_to "/events/#{login}"
  end

  def list
    @user = user_for(login)
    @events = events_for(@user)
  rescue Octokit::NotFound
    render(template: "events/user_not_found", status: :not_found) && return
  end

  def login
    @login ||= params[:login]
  end
  helper_method :login

  private

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
