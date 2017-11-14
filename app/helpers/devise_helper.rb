module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    message = content_tag(:ul, resource.errors.full_messages
      .map { |msg| content_tag(:li, msg.html_safe) }.join.html_safe, class: 'list-unstyled mb-0')
      .html_safe

    toast message, type: :error
  end
end
