class Api::GovernmentUrlController < ApplicationController

  SEARCH_PARAMS = [:offset, :size, :q, :states, :scope_ids]

  def search
    search_params = params.permit(SEARCH_PARAMS)
    @search = GovernmentUrl.search_for(search_params)
    render
  end

end
