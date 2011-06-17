ENV['RAILS_ENV'] ||= 'development'
# require rails environment file which basically "boots" up rails for this script
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'net/imap'
require 'net/http'

# amount of time to sleep after each loop below
SLEEP_TIME = 60

# mail.yml is the imap config for the email account (ie: username, host, etc.)
#config = YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'mailers.yml')))['development']['Nicolas']

# this script will continue running forever
loop do
  begin
    # make a connection to imap account
    imap = Net::IMAP.new("imap.gmail.com", 993, true)
    imap.login("onlywoodnoreply@gmail.com", "onlywood")
    # select inbox as our mailbox to process
    imap.select('Inbox')


    # get all emails that are in inbox that have not been deleted
    imap.uid_search(["NOT", "DELETED"]).each do |uid|
      # fetches the straight up source of the email for tmail to parse
      source   = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']

      Document.receive(source)


      imap.uid_store(uid, "+FLAGS", [:Deleted])

    end

    # expunge removes the deleted emails
    imap.expunge
    imap.logout
    imap.disconnect

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
