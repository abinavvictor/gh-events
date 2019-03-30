require 'octokit'

class EventsController < ApplicationController

  # ------------------------------------------------------------
  # Actions

  def index
    flash[:error] = nil
    if (q_login = request.query_parameters[:login])
      redirect_to pretty_url_for(q_login)
      return
    end
    update_user!
    update_events_table!
  rescue Octokit::NotFound
    flash[:error] = "The user ‘#{login}’ could not be found."
    render(status: :not_found)
  end

  # ------------------------------------------------------------
  # Pagination helpers

  def current_page
    @current_page ||= begin
      page = params[:page].to_i
      page > 0 ? page : 1
    end
  end
  helper_method :current_page

  def prev_page
    @prev_page ||= page_from(:prev)
  end
  helper_method :prev_page

  def next_page
    @next_page ||= page_from(:next)
  end
  helper_method :next_page

  def last_page
    @last_page ||= (page_from(:last) || current_page)
  end
  helper_method :last_page

  def login
    @login ||= request.path_parameters[:login]
  end
  helper_method :login

  # ------------------------------------------------------------
  # Private methods

  private

  def pretty_url_for(q_login)
    redirect_path = "/#{q_login}"
    return redirect_path if current_page == 1
    redirect_path + "/#{current_page}"
  end

  def client
    @client ||= Octokit::Client.new
  end

  def update_user!
    @user = login && client.user(login)
  end

  def update_events_table!
    return unless @user

    @events = events_for(@user)
  end

  def events_for(user)
    return [] unless user
    # TODO: something smarter with Sawyer pagination? https://github.com/octokit/octokit.rb#pagination
    return client.user_events(user.id) if current_page == 1
    client.user_events(user.id, { query: { page: current_page } })
  end

  def page_from(rel)
    return unless rel
    return unless (last_response = client.last_response)
    return unless (link = last_response.rels[rel])
    return unless (query = URI.parse(link.href).query)

    query_params = Rack::Utils.parse_query(query)
    page = query_params['page'].to_i
    page if page > 0
  end
end
