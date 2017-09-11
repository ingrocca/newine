json.array!(@brands) do |user|
  json.(user, :id, :name)
end
