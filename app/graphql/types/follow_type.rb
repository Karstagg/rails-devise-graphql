module Types
  class FollowType < BaseObject
    field :id, ID, null: false
    field :followed_user, Integer, null: false
    field :posted_by, UserType, null: true, method: :user
  end
end