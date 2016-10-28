describe "a Clinton voter setting their match preference from the link in email" do
  let!(:user1) do
    User.create email: "p.witty@gmail.com", password: "password", state: "CA", desired_candidate: CLINTON, name: "Steve H"
  end

  before do
    sign_in user1
  end

  context "when there's an appropriate match" do
    let!(:user2) do
      User.create email: "test@example.com", password: "password", state: "OH", desired_candidate: STEIN, name: "Testy Tester"
    end

    it "matches them & sets their preference" do
      expect {
        get "/update-match-preference", params: {pref: STEIN}
      }.to change(ActionMailer::Base.deliveries, :count).by 2

      expect(user1.reload.match).to eq user2
      expect(user1.match_preference).to eq [STEIN]
      expect(user2.reload.match).to eq user1
    end
  end

  context "when there's no appropriate match" do
    let!(:user2) do
      User.create email: "test@example.com", password: "password", state: "OH", desired_candidate: JOHNSON, name: "Testy Tester"
    end

    it "just sets their match preference" do
      get "/update-match-preference", params: {pref: STEIN}

      expect(user1.reload.match).to eq nil
      expect(user1.match_preference).to eq [STEIN]
      expect(user2.reload.match).to eq nil
    end
  end
end
