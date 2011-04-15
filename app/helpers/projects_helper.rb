module ProjectsHelper
  def get_component_type
    ProjectComponent.get_component_type
  end
  def get_component_matter
    ProjectComponent.get_component_matter
  end
  def get_project_type
    Project.get_project_type
  end
  def get_remaining_to_pay project
    if !project.project_price.nil?
      project.invoices.sum(:total_sum)-project.invoices.sum(:remaining_sum)
    end
  end
end
