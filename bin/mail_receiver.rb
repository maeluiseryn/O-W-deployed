ENV['RAILS_ENV'] ||= 'production'
# require rails environment file which basically "boots" up rails for this script
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'net/imap'
require 'net/http'

# amount of time to sleep after each loop below
SLEEP_TIME = 60

# mail.yml is the imap config for the email account (ie: username, host, etc.)
config_hash = YAML.load(File.read(File.join(Rails.root.to_s, 'config', 'mailers.yml')))[ENV['RAILS_ENV']]

# this script will continue running forever
loop do

  begin
    config_hash.each_key do |config|
    puts " try connect #{config_hash[config]['user_name']}"
    # make a connection to imap account
    imap = Net::IMAP.new(config_hash[config]['host'], config_hash[config]['port_imap'], true)
    imap.login(config_hash[config]['user_name'], config_hash[config]['password'])
    puts "connected #{config_hash[config]['user_name']}"
    # select inbox as our mailbox to process
    imap.select('Inbox')


    # get all emails that are in inbox that have not been deleted
    imap.uid_search(["NOT", "DELETED"]).each do |uid|
      # fetches the straight up source of the email for tmail to parse
      source   = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']
     puts 'avant receive'
      Document.receive(source)


      imap.uid_store(uid, "+FLAGS", [:Deleted])

    end

    # expunge removes the deleted emails
    imap.expunge
    imap.logout
    imap.disconnect
  end
  # NoResponseError and ByResponseError happen often when imap'ing
  rescue Net::IMAP::NoResponseError => e
    # send to log file, db, or email
  rescue Net::IMAP::ByeResponseError => e
    # send to log file, db, or email
  rescue => e
    # send to log file, db, or email
  end

  # sleep for SLEEP_TIME and then do it all over again
  sleep(SLEEP_TIME)
end
