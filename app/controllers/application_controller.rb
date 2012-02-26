class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  helper :all
  include SslRequirement unless (Rails.env.development? or
  Rails.env.test?)
end
