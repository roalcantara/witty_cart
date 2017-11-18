module TrackerHelper
  def track(event, attributes = {})
    content_for :js do
      track_script event, attributes
    end if WittyCart.tracking?
  end

  def track_script(event, attributes)
    %($(document).on('turbolinks:load', function() {
        WittyCart.tracker.track('#{event}', #{attributes.to_json});
      });
    ).html_safe
  end
end
