module BreadcrumbHelper
  def breadcrumb(bread, last: false)
    return last ? bread[0] : link_to(*bread) if bread.is_a?(Array)
    bread
  end
end
