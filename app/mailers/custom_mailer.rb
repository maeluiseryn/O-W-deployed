class CustomMailer < ActionMailer::Base
  def smtp_settings_reload(name)
          options = YAML.load_file("#{RAILS_ROOT}/config/mailers.yml")[Rails.env][name]
          ActionMailer::Base.smtp_settings = {
            :address => options["address"],
            :port => options["port"],
            :domain => options["domain"],
            :authentication => options["authentication"],
            :user_name => options["user_name"],
            :password => options["password"],
            :tls => options["tls"]
          }
        end

 def custom_mail(email,file,current_user)
     self.smtp_settings_reload(current_user.name)
      @email=email
      @file=file
     if @file != nil
      attachments[@file.original_filename] = @file.read
     end
      mail(:to => @email.email,
         :from =>"n0st4lg1af0r1nf1n1ty@gmail.com",
         :subject => @email.subject)
   end
end
