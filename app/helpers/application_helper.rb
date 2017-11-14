module ApplicationHelper
  def current_year
    Date.current.year
  end

  def error?(resource, field)
    'is-invalid' if resource.errors[field].any?
  end

  def error(resource, field)
    content_tag :div,
                resource.errors[field].join(', ').html_safe,
                class: 'invalid-feedback d-block mt-0' if resource.errors[field].any?
  end
end
