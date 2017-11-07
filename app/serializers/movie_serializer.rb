class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :overview, :inventory, :release_date
end
