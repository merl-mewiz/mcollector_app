class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def errors_to_html(obj)
    return unless obj.errors.any?

    error_msg = "<h6>Ошибки (#{obj.errors.count}):</h6><ul class=\"error-notice\">"
    obj.errors.full_messages.each do |msg|
      error_msg += "<li><span class=\"material-icons error-circle\">cancel</span> #{msg}</li>"
    end
    error_msg += '</ul>'

    error_msg
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:fio, :email, :phone, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:fio, :email, :phone, :password, :password_confirmation, :current_password) }
  end
end
