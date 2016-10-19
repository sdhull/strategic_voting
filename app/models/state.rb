class State < ActiveRecord::Base
  self.primary_key = "short_name"

  def self.for_select
    where.not(name:  'Fake').order(:name).map do |state|
      [state.name, state.short_name]
    end
  end

  def self.swing
    where("optimistic_win_p - pessimistic_win_p >= 10")
  end

  def self.uncontested
    where("optimistic_win_p - pessimistic_win_p < 10")
  end

  def swing?
    optimistic_win_p - pessimistic_win_p > 10
  end
end
