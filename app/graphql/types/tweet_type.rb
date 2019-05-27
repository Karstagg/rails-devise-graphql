module Types
  class TweetType < BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :posted_by, UserType, null: true, method: :user
  end
end