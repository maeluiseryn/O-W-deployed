# encoding: UTF-8

class Document < ActionMailer::Base
   def receive(email)
   body=nil

    email.body.parts.each do |p|
       if p.mime_type == "text/html"
             body = p.body

          end
       end

    File.open("#{RAILS_ROOT}/public/mails.html", "a+") { |f| f.write(body)}
   end
   def fiche_de_rendez_vous(project)
        @flag=1
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
  
end
