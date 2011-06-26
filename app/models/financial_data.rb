class FinancialData < ActiveRecord::Base
TVA_RATES=['21%','6%','0%']
TVA_RATES_FLOAT=[0.21,0.06,0]

belongs_to :client

validates :tva_rate ,:presence=>true ,:inclusion => {:in =>TVA_RATES  }
validates :tva_number , :format     => {:if =>Proc.new { |o| !o.tva_number.blank? }, :with => /([a-zA-Z]{2}[0-9]{4}[.][0-9]{3}[.][0-9]{3})|([a-zA-Z]{2}\s[0-9]{4}[.][0-9]{3}[.][0-9]{3}) /i}
validates :bank_account , :format     => { :with => /([a-zA-Z]{2}[0-9]{2}[-][0-9]{3}[-][0-9]{7}[-][0-9]{2})|([a-zA-Z]{2}[0-9]{2}[-][0-9]{10}[-][0-9]{2})|([a-zA-Z]{2}[0-9]{2}[-][0-9]{12})|([0-9]{3}[-][0-9]{7}-[0-9]{2}) /i} ,:if =>Proc.new{|o| !o.bank_account.blank? }

def self.get_tva_rate
  TVA_RATES
end
def get_tva_rate_float
  if self.tva_rate =='0%'
    TVA_RATES_FLOAT[2]
  elsif self.tva_rate =='6%'
    TVA_RATES_FLOAT[1]
  elsif self.tva_rate =='21%'
    TVA_RATES_FLOAT[0]
  end
end
end
