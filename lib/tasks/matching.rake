namespace :matching do
  task :match do
    User.unmatched.in_swing_state.third_party.find_each do |user1|
      break unless user2 = User.unmatched.in_uncontested_state.clinton.first
      user1.match_with user2
    end
  end
end
