# encoding: UTF-8
class Document < ActionMailer::Base



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


   def fiche_de_rendez_vous(project)
        @project=project
        #attachments['rails.png'] = File.read(Rails.root.to_s+'/public/images/rails.png')
        mail(:to => "nicolas@onlywood.be",
        :from =>"n0st4lg1af0r1nf1n1ty@gmail.com",
        :subject => "Nouvelle fiche de rendez-vous #{@project.project_ref_string}")
   end

   def sav_form(project)
        @project=project
        attachments['Formulaire_de_SAV.pdf'] = File.read(Rails.root.to_s+'/public/data/documents/Formulaire_de_SAV.pdf')
        mail(:to => @project.client.contacts.where("genre = 'Email'").first.contact_data ,# if more than one email must check .....
        :from =>"n0st4lg1af0r1nf1n1ty@gmail.com",
        :subject => "Formulaire de service après-ventes pour le projet: #{@project.project_ref_string}")
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
