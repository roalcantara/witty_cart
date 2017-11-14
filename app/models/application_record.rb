class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.pluralized_model_name
    model_name.human count: 2
  end
end
