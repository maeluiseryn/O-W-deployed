# encoding: UTF-8

class Document < ActionMailer::Base
   def prepare_receive(email,user_name)
     if user=User.find_by_name(user_name)
     puts 'user trouvé'+user.name
     end
     receive(email)
   end
   def receive(email)
   puts 'in receive'

   body=nil
   email.body.parts.each do |p|
       if p.mime_type == "text/html"
           puts  body = p.body

       end
   end



   puts email_db=EmailDb.new(:subject=>email.subject.to_s,:from=>email.from.to_yaml ,:to=>email.to ,:content=>body.to_yaml)

  puts  email_db.content.size
   puts email_db.save

    File.open("#{RAILS_ROOT}/public/mails.html", "a+") { |f| f.write(body)}
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
