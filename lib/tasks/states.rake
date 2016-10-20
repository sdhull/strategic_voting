namespace :states do
  task create: :environment do
    YAML.load_file("lib/active_hash/data/states.yml").each do |state_hash|
      next if State.where(state_hash.slice(:short_name, :name, :slug)).exists?
      State.create state_hash.slice(:short_name, :name, :slug)
    end
  end

  task update_stats: :environment do
    require 'csv'
    CSV.open("lib/assets/ev_stateprobs.csv", headers: true).each do |probs|
      state = State.find_by_short_name probs["state_code"]
      state.electoral_votes = probs["electoral_votes"]
      state.optimistic_win_p = probs["optimistic_win_p"]
      state.pessimistic_win_p = probs["pessimistic_win_p"]
      state.nov_win_p = probs["nov_win_p"]
      state.win_margin = probs["win_margin"]
      state.save
    end
  end
end
