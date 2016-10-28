require "support/email_params"

describe "incoming email parsing" do
  let!(:from) do
    User.create email: "p.witty@gmail.com", password: "password", state: "CA", desired_candidate: CLINTON, name: "Steve H"
  end
  let!(:to) do
    User.create email: "test@example.com", password: "password", state: "OH", desired_candidate: STEIN, name: "Testy Tester", uuid: "f32e22fd-e822-4e18-970c-8d0e23863dd1"
  end

  it "creates a new message" do
    expect {
      post "/messages/forward", email_params
    }.to change(Message, :count).by 1
  end

  it "trims out the quoted reply text" do
    post "/messages/forward", email_params
    message = Message.last
    message.body.should == "Weird. I thought it would trim the reply portion better.\n\n-S"
  end
end
