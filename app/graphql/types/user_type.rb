module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :user_name, String, null: false
    field :email, String, null: true
    field :token, String, null: false
  end
end
