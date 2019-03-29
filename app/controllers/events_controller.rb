require 'octokit'

class EventsController < ApplicationController

  def index
    @user = user_for(login)
    @events = events_for(@user)
  rescue Octokit::NotFound
    render(template: 'events/user_not_found', status: :not_found) && return
  end

  def current_page
    @current_page ||= begin
      page = params[:page].to_i
      page > 0 ? page : 1
    end
  end
  helper_method :current_page

  attr_reader :prev_page
  helper_method :prev_page

  attr_reader :next_page
  helper_method :next_page

  attr_reader :last_page
  helper_method :last_page

  private

  def client
    @client ||= Octokit::Client.new
  end

  def events_for(user)
    return [] unless user

    # TODO: something smarter with Sawyer pagination? https://github.com/octokit/octokit.rb#pagination
    options = params[:page] ? { query: { page: current_page } } : {}
    events = client.user_events(user.id, options)
    update_page_numbers(client.last_response)
    events
  end

  def update_page_numbers(last_response)
    @prev_page = page_from(last_response.rels[:prev])
    @next_page = page_from(last_response.rels[:next])
    @last_page = page_from(last_response.rels[:last]) || 1
  end

  def user_for(login)
    return unless login

    client.user(login)
  end

  def page_from(rel)
    return unless rel

    query = URI.parse(rel.href).query
    return unless query

    query_params = Rack::Utils.parse_query(query)
    page = query_params['page'].to_i
    page if page > 0
  end
end
