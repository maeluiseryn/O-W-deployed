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
    [['Modifier',:created_at],['Creer',:updated_at]]
  end
  def created
    [['jours',:day],['semaines',:weak],['mois',:month],['ans',:year]]
  end
end
