class ApplicationController < ActionController::API


  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
    @current_user = user
  end

  def logout!
    # reset the `current_user`'s session cookie, if one exists
    # clear out token from `session` cookie
    current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil # so that subsequent calls to `current_user` return nil
  end

  def require_logged_in
    unless current_user
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end


  def test
        if params.has_key?(:login)
            login!(User.first)
        elsif params.has_key?(:logout)
            logout!
        end 
        if current_user
            render json: { user: current_user.slice('id', 'username', 'session_token') }
        else
            render json: ['No current user']
        end
    end

  def require_logged_in
  unless current_user
    render json: { message: 'Unauthorized' }, status: :unauthorized 
  end
end


end
