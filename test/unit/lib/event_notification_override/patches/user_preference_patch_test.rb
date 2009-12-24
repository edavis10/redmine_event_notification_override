require File.dirname(__FILE__) + '/../../../../test_helper'

class EventNotificationOverride::Patches::UserPreferencePatchTest < ActiveSupport::TestCase
  context "UserPreference#[:no_self_notified]" do
    setup do
      @user = User.generate_with_protected!(:login => 'test')
      @preference = UserPreference.generate!
      @preference[:no_self_notified] = true
      @user.preference = @preference
      @user.save
    end

    context "with event_notification_override disabled" do
      should "return the attribute" do
        configure_plugin('enabled' => '0')
        assert_equal true, @user.pref[:no_self_notified]
      end
    end

    context "with event_notification_override enabled" do
      context "with notify_users_of_their_own_changes on" do
        should "return false" do
          configure_plugin('enabled' => '1', 'notify_users_of_their_own_changes' => 'all')
          assert_equal false, @user.pref[:no_self_notified]
        end
      end

      context "with notify_users_of_their_own_changes off" do
        should "return true" do
          configure_plugin('enabled' => '1', 'notify_users_of_their_own_changes' => '')
          assert_equal true, @user.pref[:no_self_notified]
        end
      end
    end
  end
end
