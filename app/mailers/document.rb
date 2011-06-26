# encoding: UTF-8

class Document < ActionMailer::Base

   def receive(email)
   puts 'in receive'

   body=nil
   email.body.parts.each do |p|
       if p.mime_type == "text/html"
           puts  body = p.body

       end
   end

   puts email_db=EmailDb.new(:subject=>email.subject.to_s,:from=>email.from.to_yaml ,:to=>email.to )

   puts email_db.save

   File.open("#{RAILS_ROOT}/public/mail/#{email_db.id}.html", "wb") { |f| f.write(body.to_s)}
     email_db.content="/mail/#{email_db.id}.html"
     email_db.save
    #html =File.open("#{RAILS_ROOT}/public/mails.html", "r").read
    #doc = Nokogiri::HTML(html)
    #puts doc
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
