class UsersController < ApplicationController
  def show
    @res = Views.fetch("my_views/all_by_user_and_created_at", :include_docs => true, :descending => true)
    @items = @res['rows'].map {|x| x['doc']}
  end

  def index
  end

end
