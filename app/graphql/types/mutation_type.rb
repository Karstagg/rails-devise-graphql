module Types
  class MutationType < Types::BaseObject
    field :create_tweet, mutation: Mutations::CreateTweet
    field :create_follow, mutation: Mutations::CreateFollow
    ## LOGIN
    field :login, UserType, null: true do
      argument :email, String, required: true
      argument :password, String, required: true
    end
    def login(email:, password:)
      user = User.find_for_authentication(email: email)
      return nil if !user
      
      is_valid_for_auth = user.valid_for_authentication?{
        user.valid_password?(password)
      }
      return is_valid_for_auth ? user : nil
    end

    ## TOKEN-LOGIN
    field :token_login, UserType, null: true
    def token_login
      context[:current_user]
    end

    ## LOGOUT
    field :logout, Boolean, null: true
    def logout
      if context[:current_user]
        context[:current_user].update(jti: SecureRandom.uuid)
      end 
      true
    end

    # Uncomment to enable features
  
    field :update_user, UserType, null: true do
      argument :password, String, required: false
      argument :passwordConfirmation, String, required: false
    end

    def update_user(
        password: context[:current_user] ? context[:current_user].password : '',
        password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ''
      )
      user = context[:current_user]
      return nil if !user
      user.update(
        password: password,
        password_confirmation: password_confirmation
      )
      user
    end
  
    field :sign_up, UserType, null: true do
      argument :email, String, required: true
      argument :password, String, required: true
      argument :passwordConfirmation, String, required: true
      argument :userName, String, required: true

    end
    def sign_up(email:, password:, password_confirmation:, user_name:)
      User.create(
        email: email, 
        password: password, 
        password_confirmation: password_confirmation, 
        user_name: user_name
      )
    end

    field :send_reset_password_instructions, Boolean, null: true do
      argument :email, String, required: true
    end
    def send_reset_password_instructions(email:)
      user = User.where(email: email).first
      return false if !user
      user.send_reset_password_instructions
    end

    field :reset_password, Boolean, null: true do
      argument :password, String, required: true
      argument :passwordConfirmation, String, required: true
      argument :resetPasswordToken, String, required: true
    end
    def reset_password(password:, password_confirmation:, reset_password_token:)
      user = User.with_reset_password_token(reset_password_token)
      return false if !user
      user.reset_password(password, password_confirmation)
    end  

    #
    # uncomment for unlock instructions
    # 
    # field :unlock, Boolean, null: false do
    #   argument :unlockToken, String, required: true
    # end
    # def unlock(unlock_token:)
    #   user = User.unlock_access_by_token(unlock_token)
    #   return user.id
    # end

    # field :resend_unlock_instructions, Boolean, null: false do
    #   argument :email, String, required: true
    # end
    # def resend_unlock_instructions(email:)
    #   user = User.where(email: email).first
    #   return false if !user

    #   user.resend_unlock_instructions
    # end
  end
end
  