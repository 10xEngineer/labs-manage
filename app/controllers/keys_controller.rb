require 'sshkey'
require 'key'

class KeysController < ProtectedController
  def index
    begin
      @keys = Key.where(user_id: @current_user._id).to_a
    rescue Mongoid::Errors::DocumentNotFound
      @keys = []
    end

  	@key = Key.new
  end

  def create
  	@key = Key.new(params[:key])

    # check pem public key
    key = @key.public_key.strip
    if key.match /^-----BEGIN/
      pem_key = KeyConvertor.new(@key.public_key)

      @key.public_key = pem_key.ssh_public_key
    end

    parts = @key.public_key.split(' ')
    _key = parts[0..1].join(' ')

  	@key.fingerprint = SSHKey.fingerprint(_key)
  	@key.user_id = @current_user._id

  	if SSHKey.valid_ssh_public_key?(@key.public_key) && @key.save  		
      $customerio.delay.track(@current_user, "key_created")
  		redirect_to user_keys_path(@current_user), :notice => "New SSH Key added!"  		
  	else
      begin
        @keys = Key.where(user_id: @current_user._id).to_a
      rescue Mongoid::Errors::DocumentNotFound
        @keys = []
      end

  		redirect_to user_keys_path(@current_user), :notice => "Invalid SSH Key"      
  	end
  end

  def destroy
  	@key = Key.find_by(name: params[:id], user_id: params[:user_id])
    @key.destroy

    $customerio.delay.track(@current_user, "key_destroyed")

    logger.warn "#{Time.new.utc} key=#{@key._id} removed by user=#{@current_user._id}"

  	redirect_to user_keys_path(@current_user), :notice => "SSH Key removed!"
  end
end
