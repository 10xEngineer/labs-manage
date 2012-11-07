require 'sshkey'

class KeysController < ProtectedController
  def index
  	@keys = @current_user.keys

  	@key = Key.new
  end

  def create
  	@key = Key.new(params[:key])

    parts = @key.public_key.split(' ')
    _key = parts[0..1].join(' ')

  	@key.fingerprint = SSHKey.fingerprint(_key)
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
    @key.deleted_at = Date.new
  	@key.save

    logger.warn "key=#{@key._id} removed by user=#{@current_user._id}"

  	redirect_to user_keys_path(@current_user), :notice => "SSH Key removed!"
  end
end
