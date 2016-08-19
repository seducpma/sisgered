class JavascriptsController < ApplicationController
  def hide_announcement
    t=0
    session[:announcement_hide_time] = Time.current
  end
end
