class Configurations::Form < Configuration

  serialize :data, Document::Concerns::VirtualModels::AdvancedSearch::Builder

  after_initialize do
    if respond_to? :data
      self.data ||= {}
    end
  end

end
