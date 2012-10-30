class KeysController < ProtectedController
  def index
  	@keys = @current_user.keys
  end
end
