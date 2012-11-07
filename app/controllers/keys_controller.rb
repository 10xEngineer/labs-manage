require 'sshkey'

class KeysController < ProtectedController
  def index
    begin
      @keys = Key.where(user_id: @current_user._id).to_a

      @keys = @keys.select {|k| k.deleted_at.nil?}
    rescue Mongoid::Errors::DocumentNotFound
      @keys = []
    end

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
      begin
        @keys = Key.where(user_id: @current_user._id).to_a

        @keys.reject {|k| !k.deleted_at.nil?}
      rescue Mongoid::Errors::DocumentNotFound
        @keys = []
      end

  		render :index
  	end
  end

  def destroy
  	@key = Key.find_by(name: params[:id])
    @key.deleted_at = Time.now.utc
  	@key.save

    @current_user.reload

    logger.warn "key=#{@key._id} removed by user=#{@current_user._id}"

  	redirect_to user_keys_path(@current_user), :notice => "SSH Key removed!"
  end
end
