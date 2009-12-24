require File.dirname(__FILE__) + '/../test_helper'

class MailerIntegrationTest < ActionController::IntegrationTest
  context "sending mail with event overrides off" do
    setup do
      configure_plugin('enabled' => '0')
      @author = User.generate_with_protected!
      @preference = UserPreference.generate!
      @preference[:no_self_notified] = false
      @author.preference = @preference
      User.current = @author
      
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project, :author => @author)
      User.anonymous
    end

    should "include the author in the emails according to their perference" do
      mail = Mailer.create_issue_add(@issue)
      assert mail.bcc.include?(@author.mail)
    end
  end

  context "sending mail with event overrides on and a systemwide setting of 'notify_users_of_their_own_changes' set to 'all'" do
    setup do
      configure_plugin('enabled' => '1', 'notify_users_of_their_own_changes' => 'all')
      @author = User.generate_with_protected!
      @preference = UserPreference.generate!
      @preference[:no_self_notified] = true
      @author.preference = @preference
      User.current = @author
      
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project, :author => @author)
      User.anonymous
    end

    should "include the author in the emails" do
      mail = Mailer.create_issue_add(@issue)
      assert mail.bcc.include?(@author.mail)
    end
  end

  context "sending mail with event overrides on and a systemwide setting of 'notify_users_of_their_own_changes' set to none" do
    setup do
      configure_plugin('enabled' => '1', 'notify_users_of_their_own_changes' => '0')
      @author = User.generate_with_protected!
      @preference = UserPreference.generate!
      @preference[:no_self_notified] = true
      @author.preference = @preference
      User.current = @author
      
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project, :author => @author)
      User.anonymous
    end

    should "not include the author in the emails" do
      mail = Mailer.create_issue_add(@issue)
      assert_nil mail.bcc
      assert_nil mail.to
      assert_nil mail.cc
    end
  end
end
