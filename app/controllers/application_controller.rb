class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

private
  def set_locale
    I18n.locale = session[:locale] or I18n.default_locale
  end
end
