class ProjectAction < ActiveRecord::Base
  include AASM
   ACTION_TYPE=["Choisir type d'action","Rendez-vous","Offre","Production","Placement","Autres"] #emission de facture trouver un truc
   PRODUCING_SOCIETY=["Interwindows","Prowood"]
   belongs_to :user
   belongs_to :project

   scope :open_actions , :conditions => [ "action_state == 'open'" ]
   scope :failed_actions , :conditions => [ "action_state == 'failure'" ]
   scope :succeeded_actions , :conditions => [ "action_state == 'success'" ]
   #scope :invoice_action , :conditions => [ "action_type == 'facturation'" ]

   aasm_column :action_state # defaults to aasm_state

       aasm_initial_state :open

       aasm_state :open
       aasm_state :success
       aasm_state :failure



       aasm_event :succeed do
         transitions :to => :success, :from => [:open]
       end

       aasm_event :failed do
         transitions :to => :failure , :from => [:open]
       end

   def self.get_action_type
     ACTION_TYPE
   end
   def self.get_producing_society
     PRODUCING_SOCIETY
   end
   def success_or_failure(result)
      self.action_end=Date.today
     if result=='success'
       self.succeed
       self.save
     elsif result=='failure'
       self.failed
       self.save
     end
   end

end
