class Invoice < ActiveRecord::Base
  include AASM
  belongs_to :project
  has_many :payments

  scope :paid_invoices , :conditions => [ "invoice_state = 'paid'" ]

  aasm_column :invoice_state # defaults to aasm_state

    aasm_initial_state :emitted

    aasm_state :emitted
    aasm_state :paid
    aasm_state :unpaid

    aasm_event :has_been_paid do
      transitions :to => :paid, :from => [:emitted , :unpaid]
    end
    aasm_event :past_due do
      transitions :to => :unpaid, :from => [:emitted]
    end
    aasm_event :reopen_due_to_error do
      transitions :to => :emitted, :from => [:paid]
    end

end
