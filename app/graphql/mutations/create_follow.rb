module Mutations
  class CreateFollow < BaseMutation
    # arguments passed to the `resolved` method
    argument :followed_user_id, ID, required: true

    # return type from the mutation
    type Types::FollowType

    def resolve(followed_user_id: nil)
      Follow.create!(
          followed_user: followed_user_id,
          user: context[:current_user]
      )
    end
  end
end