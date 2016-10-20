feature "signing up", js: true do
  before do
    visit root_path
    click_on "Count Me In!"
  end

  scenario "as a Clinton voter in a safe state" do
    fill_in "Name", with: "Clinton Supporter"
    fill_in "Email", with: "imwith@her.com"
    fill_in "Phone", with: "510-555-1212"
    fill_in "user_password", with: "password"
    fill_in "Password Confirmation", with: "password"
    select "Texas", from: "State"
    select "Hillary Clinton", from: "Who did you want to vote for?"
    expect {
      click_on "Create Account"
      expect(page).to have_content "Welcome! You have signed up successfully."
    }.to change(User, :count).by(1)
    select STEIN, from: "Match Preference"
    click_on "Save Preference"
    expect(page).to have_content "Your account has been updated successfully."
    expect(page).to have_content "Confirm Your Account to Continue"

    u = User.last
    expect(u.name).to eq "Clinton Supporter"
    expect(u.email).to eq "imwith@her.com"
    expect(u.phone).to eq "5105551212"
    expect(u.state).to eq "TX"
    expect(u.desired_candidate).to eq "Hillary Clinton"

    expect(ActionMailer::Base.deliveries.count).to eq 1
    email = ActionMailer::Base.deliveries.last
    html = Capybara.string(email.html_part.decode_body)
    expect(html).to have_content "Please confirm your account email"
    link = html.find("a", text: "Confirm my account")
    visit link["href"]
    expect(page).to have_content "Your email address has been successfully confirmed."
    expect(page).to have_content "Waiting to be Matched"
  end

  scenario "as a 3rd-party voter in a swing state" do
    fill_in "Name", with: "Stein Supporter"
    fill_in "Email", with: "green@example.com"
    fill_in "Phone", with: "510-555-1212"
    fill_in "user_password", with: "password"
    fill_in "Password Confirmation", with: "password"
    select "Ohio", from: "State"
    select "Jill Stein", from: "Who did you want to vote for?"
    expect {
      click_on "Create Account"
      expect(page).to have_content "Welcome! You have signed up successfully."
    }.to change(User, :count).by(1)
    expect(page).to_not have_content "Match Preference"

    u = User.last
    expect(u.name).to eq "Stein Supporter"
    expect(u.email).to eq "green@example.com"
    expect(u.phone).to eq "5105551212"
    expect(u.state).to eq "OH"
    expect(u.desired_candidate).to eq "Jill Stein"

    expect(ActionMailer::Base.deliveries.count).to eq 1
    email = ActionMailer::Base.deliveries.last
    html = Capybara.string(email.html_part.decode_body)
    expect(html).to have_content "Please confirm your account email"
    link = html.find("a", text: "Confirm my account")
    visit link["href"]
    expect(page).to have_content "Your email address has been successfully confirmed."
    expect(page).to have_content "Waiting to be Matched"
  end
end
