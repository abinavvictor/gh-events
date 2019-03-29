require 'octokit'

class EventsController < ApplicationController

  def index
  end

  def list
    @user = user_for(params[:id])
    @events = events_for(@user)
  end

  private

  def client
    @client ||= Octokit::Client.new
  end

  def events_for(user)
    return [] unless user
    client.user_events(user.id)
  end

  def user_for(id)
    return unless id
    client.user(id)
  end
end
