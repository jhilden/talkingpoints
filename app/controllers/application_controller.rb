# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :current_user_is_admin?
  
  # used to make helper methods available in controllers (for location_controller.format_location_output)
  def view_helper
    Helper.instance
  end

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def current_user_is_admin?
      if current_user
        return @current_user.is_admin?
      else
        return false
      end
    end
  
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def require_admin
      require_user
      unless @current_user.is_admin?
        logger.debug(@current_user.to_s)
        store_location
        flash[:notice] = "You must have admin privileges to do this"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_here(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  
    # used to make helper methods available in controllers (for location_controller.format_location_output)
    class Helper
      include Singleton
      include ActionView::Helpers::DateHelper
    end
end
