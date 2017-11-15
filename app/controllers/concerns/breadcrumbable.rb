module Breadcrumbable
  extend ActiveSupport::Concern

  included do
    helper_method :breadcrumbs

    def breadcrumbs
      @breadcrumbs ||= [
        ['Home', root_path]
      ]
    end

    def add_breadcrumb(bread)
      breadcrumbs << case bread
                     when ->(n) { n.is_a?(ApplicationRecord) }
                       breadcrumb_for_resource(bread)
                     when ->(n) { n.try(:model_name) }
                       breadcrumb_for_domain_class(bread)
                     else
                       bread.to_s
                     end
    end
  end

  def url_params_for(clazz, action, id = nil)
    url_for(
      {
        only_path: true,
        controller: clazz.model_name.plural,
        action: action,
        id: id
      }.delete_if { |_, v| v.nil? }
    )
  end

  def breadcrumb_for_domain_class(clazz)
    [clazz.pluralized_model_name, url_params_for(clazz, :index)]
  end

  def breadcrumb_for_resource(resource)
    [resource.to_s, url_params_for(resource.class, :show, resource.id)]
  end
end
