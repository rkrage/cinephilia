module ApplicationHelper
  # Return a title on a per-page basis.
  def title
    base_title = "Cinephilia"
    if @title.nil?
    base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("logo.png", :alt => "Cinephilia", :class => "round")
  end

  def authenticate
    deny_access unless signed_in?
  end

end
