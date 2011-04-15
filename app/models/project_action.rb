class ProjectAction < ActiveRecord::Base
  include AASM
   ACTION_TYPE=["none","development","design","Rendez-vous","Offre de Prix","Emission de Facture","Production","Placement"]
   belongs_to :user
   belongs_to :project
   scope :open_actions , :conditions => [ "action_state == 'open'" ]
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
   def success_or_failure(result)
     if result='success'
       self.succeed
       self.save
     elsif result='failure'
       self.failed
       self.save
     end
   end

end
