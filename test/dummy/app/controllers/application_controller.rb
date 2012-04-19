class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from StandardError do |e|
    pp e.backtrace
    raise e
  end

  def current_user
  	# for testing purposes we just create a user and store it in the db
    @current_user ||= begin
    	u = User.find_by_id(session[:user_id]) || User.create(:first_name =>"Michael")
    	session[:user_id] = u.id
    	u
    end
  end
  
end
