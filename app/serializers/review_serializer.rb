class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :score, :advertisement_id
end

