namespace :matching do
  task match: :environment do
    possible = User.unmatched_swing.count
    actual = 0
    puts "--------- About to attempt to match #{possible} swing state voters"
    User.unmatched_safe.last(possible * 2).each do |user|
      # having it pull back swing state voters who somehow saved their
      # desired candidate as empty string breaks stuff
      user.match_preference.reject!(&:blank?)
      actual += 1 if user.find_a_match
    end
    puts "--------- Successfully matched #{actual} swing state voters"
  end

  task :trump_trader => :environment do
    users = User.unmatched.in_safe_state.clinton.confirmed
    users.each(&:send_trump_trader_email)
    puts "Sent emails to #{users.count} users"
  end
end
