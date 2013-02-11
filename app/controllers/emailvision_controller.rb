class EmailvisionController < ActionController::Base

  wrap_parameters false

  def callback
    requesttype = params[:type]
    token = params[:token]
    data = params[:data]
    raise ::Emailvision::Exception.new "Callback token not correct" unless token == Digest::SHA1.hexdigest("#{data[:email]}-#{User.emv_config[:callback_token]}")
    case requesttype
      when "unsubscribe"
        logger.info "Calling Unsubscribe from web callback for #{data[:email]}"
        unsubscribe(data)
      when "subscribe"
        logger.info "Calling Cleaned from web callback for #{data[:email]}"
        subscribe(data)
    end
    render :nothing => true, :status => 200
    rescue Exception => e
      logger.error e.message
      render :nothing => true, :status => 403
  end

  protected

  def subscribe(data)
    user = User.where({User.email_column.to_sym => data[:email]}).first
    raise ActiveRecord::RecordNotFound if user.nil?
    user.update_attribute(User.emailvision_enabled_column.to_sym, true) unless user.send(User.emailvision_enabled_column.to_sym) == true
    logger.info "Emailvision Webhook subscribe: Subscribed user with email #{data[:email]}"
  rescue ActiveRecord::RecordNotFound
    logger.error "Emailvision Webhook subscribe: Could not find user with email #{data[:email]}"
  end

  def unsubscribe(data)
    user = User.where({User.email_column.to_sym => data[:email]}).first
    raise ActiveRecord::RecordNotFound if user.nil?
    user.update_attribute(User.emailvision_enabled_column.to_sym, false)
    logger.info "Emailvision Webhook Unsubscribe: Unsubscribed user with email #{data[:email]}"
  rescue ActiveRecord::RecordNotFound
    logger.error "Emailvision Webhook Unsubscribe: Could not find user with email #{data[:email]}"
  end
  
end