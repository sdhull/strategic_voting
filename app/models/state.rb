class State < ActiveYaml::Base
  set_root_path "lib/active_hash/data"
  set_filename "states"
  fields :id, :name, :short_name, :country_id, :slug, :battleground

  def self.for_select
    all.map do |state|
      [state.name, state.short_name]
    end
  end
end
