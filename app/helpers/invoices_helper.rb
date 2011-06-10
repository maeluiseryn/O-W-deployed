module InvoicesHelper
  def project_remaining_to_pay(project)
    project.project_price-get_remaining_to_pay(project)
  end
  def project_remaining_to_pay_equal_zero(project)
    if project_remaining_to_pay(project)<=0
      true
    else
      false
    end
  end
end
