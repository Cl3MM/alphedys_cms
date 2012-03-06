describe User do
  describe "#send_password_reset" do
    let(:user) { Factory(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end

  describe "#user_ability" do
    let(:user) { Factory(:user)}
    let(:admin) { Factory(:admin)}

    it "admin can see all users" do
      admin = Factory(:user)
      visit login_path
      click_link "password"
      fill_in "Email", :with => user.email
      click_button "Log in"
      visit users_path
      page.should have_content("Email sent")
    end
  end
end
