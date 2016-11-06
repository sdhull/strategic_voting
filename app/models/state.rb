class State < ActiveRecord::Base
  self.primary_key = "short_name"

  def self.for_select
    where.not(short_name:  'FK').order(:name).map do |state|
      [state.name, state.short_name]
    end
  end

  def self.swing
    order("chance_to_tip DESC").where("win_margin >= -5 AND win_margin <= 5 AND chance_to_tip >= 2")
  end

  def self.uncontested
    order("optimistic_win_p - pessimistic_win_p DESC").where("win_margin < -5 AND win_margin > 5")
  end

  def swing?
    win_margin >= -5 && win_margin <= 5 && chance_to_tip >= 2
  end
end
