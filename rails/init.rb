require 'redmine'

Redmine::Plugin.register :redmine_event_notification_override do
  name 'Redmine Event Notification Override plugin'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com'
  author_url 'http://www.littlestreamsoftware.com'
  description "A Redmine plugin to override the \"I don't want to be notified of changes that I make myself\" email option systemwide."
  version '0.1.0'

  requires_redmine :version_or_higher => '0.8.7'

  settings(:partial => 'settings/event_notification_override',
           :default => {
             'enabled' => '0',
             # all == notify all users
             'notify_users_of_their_own_changes' => '' 
           })
end
