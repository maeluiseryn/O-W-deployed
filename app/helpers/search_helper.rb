module SearchHelper
  def model_list
     [['Choisir',nil],['Clients',Client ], ['Projets' ,Project] ,['Addresses',Address ],[ 'Fichiers',UploadedFile],[ 'Contacts',Contact]]
  end
  def per_page_result
    [['10'],['20'],['50'],['100']]
  end
  def client_filter
    [['Aucun','no']]+Client::CLIENT_FILTER
  end
  def client_type
    [['Tous','all']]+Client::CLIENT_TYPE
  end
  def client_state
    [['Tous','all']]+Client.aasm_states_for_select
  end
 def project_type
    [['Tous','all']]+Project::PROJECT_TYPE
  end
  def project_state
    [['Tous','all']]+Project.aasm_states_for_select
  end
  def contact_type
    [['Tous','all']]+Contact::CONTACT_TYPE
  end
  def time_type
    [['Creer',:created_at],['Modifier',:updated_at]]
  end
  def created
    [['jours',:day],['semaines',:weak],['mois',:month],['ans',:year]]
  end
  def link_for_model_options_search(model_type)
     if model_type=='Client'
       link_to_function('option client','$("#client").show(); $("#client").children().attr("disabled", false);')
     elsif  model_type=='Project'
       link_to_function('option Projet','$("#project").show(); $("#project").children().attr("disabled", false);')
     elsif  model_type=='Address'
       link_to_function('option Address','$("#address").show(); $("#address").children().attr("disabled", false);')
     elsif  model_type=='UploadedFiles'
     elsif  model_type=='Contact'
     end

  end
end
