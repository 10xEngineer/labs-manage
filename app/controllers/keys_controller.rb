require 'sshkey'

class KeysController < ProtectedController
  def index
  	@keys = @current_user.keys

  	@key = Key.new
  end

  def create
  	@key = Key.new(params[:key])
  	@key.fingerprint = SSHKey.fingerprint(@key.public_key)
  	@key.user_id = @current_user._id

  	if SSHKey.valid_ssh_public_key?(@key.public_key) && @key.save  		
		redirect_to user_keys_path(@current_user), :notice => "New SSH Key added!"  		
  	else
  		@keys = @current_user.keys
  		render :index
  	end
  end

  def destroy
  	@key = Key.find_by(name: params[:id])
  	@key.destroy

  	redirect_to user_keys_path(@current_user), :notice => "SSH Key removed!"
  end
end
