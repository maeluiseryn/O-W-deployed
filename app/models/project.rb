class Project < ActiveRecord::Base
PROJECT_TYPE=['Standard' ,'Fourniture', 'Reparation' , 'Assurance']
before_create :create_ref
include AASM
belongs_to :client

has_one  :address ,  :as => :place

has_many :user_projects
has_many :users, :through => :user_projects
has_many :project_components
has_many :contacts , :as=> :contact_ref
has_one :message_box ,:as =>:box_owner
has_many :uploaded_files , :as=>:file_owner
has_many :invoices
has_many :project_actions
accepts_nested_attributes_for :contacts ,:reject_if => lambda { |a| a[:description].blank? && a[:contact_data].blank? } ,:allow_destroy => true
accepts_nested_attributes_for :address ,:project_components
attr_accessor :add_remark
scope :incomplete, :conditions => [ "project_state != 'close'" ]

define_index do
      set_property :enable_star => 1
      set_property :min_infix_len => 3
      indexes client_id
      indexes project_ref
      indexes client.surname , :as => :client_surname
      indexes client.name ,:as=>:client_name
      has  created_at, updated_at , project_state
end
aasm_column :project_state # defaults to aasm_state

    aasm_initial_state :created

    aasm_state :created ,:exit=> :message_box_create
    aasm_state :active
    aasm_state :offer
    aasm_state :waiting_payment # not sure
    aasm_state :production
    aasm_state :placement
    aasm_state :closed
    aasm_state :waiting
    aasm_state :archive #conflict with incomplete => archive is a flag for file_system_storage+deletion so no project in the db have archive as state
    aasm_state :close
    aasm_state :after_sales_service ,:enter => :reopen_client_with_sav

    aasm_event :activated do
      transitions :to => :active, :from => [:created]
    end
    aasm_event :to_offer do
      transitions :to => :offer, :from => [:active ,:waiting], :guard => :project_user_not_empty?
    end
    aasm_event :accepted do
       transitions :to => :waiting_payment, :from => [:offer , :waiting] ,:guard => :is_price_defined?
    end
    aasm_event :in_production_schedule do
       transitions :to => :production , :from => [:waiting_payment] ,:guard =>:is_forty_percent_paid?
    end
    aasm_event :in_placement_schedule do
       transitions :to => :placement , :from => [:production] ,:guard =>:is_eighty_percent_paid?
    end
    aasm_event :closed do
      transitions :to => :close, :from => [:created, :active, :waiting] ,:guard =>:hundred_percent_paid_and_no_open_actions?
    end
    aasm_event :to_archive do
      transitions :to => :archive, :from => [:closed]
    end
    aasm_event :to_s_a_v do
      transitions :to => :after_sales_service, :from => [:closed]
    end
    def create_home_directory(public_path)
    self.home_directory=File.join("#{self.client.home_directory}/","p#{self.project_ref.to_s}")
    ServerFileOperation.create_directory({:path=>"#{self.client.home_directory}",:name=>"p#{self.project_ref.to_s}"},public_path)

  end
  def self.create_home_directory(home_directory,public_path)
    ServerFileOperation.create_directory(home_directory,public_path)
  end
  def create_ref
     ref_number=Client.find(self.client_id).projects.count
     self.project_ref=ref_number+1
  end
  def send_fiche_de_rendez_vous
     Document.fiche_de_rendez_vous(self).deliver
  end
  def send_sav_form
     Document.sav_form(self).deliver
  end
  def self.get_project_type
    PROJECT_TYPE
  end
  def project_ref_string
    "C#{client_id}P#{project_ref}"
  end
  def message_box_create
   build_message_box(:description =>self.project_ref_string+" "+client.surname.capitalize,:box_type=>'project_box')
   message_box.save
  end
  def project_to_offer
    if self.aasm_events_for_current_state.include?(:to_offer)
      if self.to_offer
          self.save
      end
    end
  end
  def is_price_defined?
    if !self.project_price.nil?
       true
    else
      false
    end
  end
  def is_forty_percent_paid?
    if self.invoices.paid_invoices.sum(:total_sum)>=(self.project_price*0.4)
       true
    else
      false
    end
  end
   def is_eighty_percent_paid?
    if self.invoices.paid_invoices.sum(:total_sum)>=(self.project_price*0.4)
       true
    else
      false
    end
  end
   def is_hundred_percent_paid?
    if self.invoices.paid_invoices.sum(:total_sum)>=self.project_price
       true
    else
      false
    end
   end

  def false_if_has_active_actions?
    if self.project_actions.open_actions.any?
     false
    else
      true

    end

  end
  def hundred_percent_paid_and_no_open_actions?
    if is_hundred_percent_paid?
      if false_if_has_active_actions?
        true
      else
        false
      end
    else
      false
    end

  end


  def reopen_client_with_sav
    self.client.reopen_with_sav
  end
  def project_user_not_empty?
    if self.users.empty?
      false
    else
      true
    end
  end
end
