require "support/email_params"

describe "incoming email parsing" do
  let!(:from) do
    User.create email: "notarealemail@gmail.com", password: "password", state: "CA", desired_candidate: CLINTON, name: "Steve H"
  end
  let!(:to) do
    User.create email: "test@blahblahblah289312.com", password: "password", state: "OH", desired_candidate: STEIN, name: "Testy Tester", uuid: "f32e22fd-e822-4e18-970c-8d0e23863dd1"
  end

  it "creates a new message" do
    expect {
      post "/messages/forward", params: email_params
    }.to change(Message, :count).by 1
    message = Message.last
    expect(message.to).to eq to
    expect(message.from).to eq from
  end

  it "trims out the quoted reply text" do
    post "/messages/forward", params: email_params
    message = Message.last
    expect(message.body).to eq "Weird. I thought it would trim the reply portion better.\n\n-S"
  end

  it "can figure it out even if the user created their email with a +token" do
    from.update_column :email, "notarealemail+throwaway-token@gmail.com"
    expect {
      post "/messages/forward", params: email_params
    }.to change(Message, :count).by 1
    message = Message.last
    expect(message.to).to eq to
    expect(message.from).to eq from
  end
end
