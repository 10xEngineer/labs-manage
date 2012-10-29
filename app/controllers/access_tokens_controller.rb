class AccessTokensController < ApplicationController
  def index
  	@tokens = current_user.access_tokens
  end
end
