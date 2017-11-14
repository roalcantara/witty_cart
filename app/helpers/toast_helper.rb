module ToastHelper
  TYPES = {
    success: :success,
    alert: :warning,
    error: :error,
    notice: :info
  }.freeze

  DEFAULT_OPTIONS = '{"showMethod": "slideDown", "progressBar": true}'.freeze

  def toasts(*messages)
    content_for :js do
      messages.map do |message|
        toastr(message[:message], type: message[:type], title: message[:title], options: message[:options])
      end.join("\n").html_safe
    end if messages&.any?
  end

  def toast(message, type: :notice, title: nil, options: nil)
    content_for :js do
      toastr message, type: type, title: title, options: options
    end
  end

  def toastr(message, type: :info, title: nil, options: nil)
    "toastr.#{TYPES[type]}('#{message&.tr("'", '`')}', '#{title&.tr("'", '`')}', #{options || DEFAULT_OPTIONS});"
      .html_safe
  end
end
