class UsersController < ApplicationController
  before_action :set_user, except: [:confirm_lock, :unsupported_browser]

  def confirm_lock
    authorize HbxProfile, :confirm_lock?
    @user_id  = params[:user_action_id]
  end

  def lockable
    authorize HbxProfile, :lockable?
    @user.lock!
    flash[:notice] = "User #{user.email} is successfully #{user.lockable_notice}."
    render file: 'users/lockable.js.erb'
  end

  def reset_password
    authorize HbxProfile, :reset_password?
    render file: 'users/reset_password.js.erb'
  end

  def confirm_reset_password
    authorize HbxProfile, :confirm_reset_password?
    @error = nil
    validate_email if params[:user].present?
    if @error.nil?
      User.send_reset_password_instructions(email: @user.email)
      redirect_to user_account_index_exchanges_hbx_profiles_url, notice: "Reset password instruction sent to user email."
    else
      render file: 'users/reset_password.js.erb'
    end
  end

  def change_username_and_email
    authorize HbxProfile, :change_username_and_email?
    @user_id = params[:user_id]
  end

  def confirm_change_username_and_email
    authorize HbxProfile, :confirm_change_username_and_email?
    @element_to_replace_id = params[:family_actions_id]
    @email_taken = User.where(:email => params[:new_email].strip, :id.ne => @user.id).first if params[:new_email]
    @username_taken = User.where(:oim_id => params[:new_oim_id].strip, :id.ne => @user.id).first if params[:new_oim_id]
    if @email_taken.present? || @username_taken.present?
      @matches = true
    else
      @user.oim_id = params[:new_oim_id] if params[:new_oim_id] != params[:current_oim_id]
      @user.email = params[:new_email] if params[:new_email] && (params[:new_email] != params[:current_email])
      begin
        @user.modifier = current_user
        @user.save!
      rescue => e
        @errors = @user.errors.messages
      end
    end
    respond_to do |format|
      format.js { render "change_username_and_email"} if @errors
      format.js { render "username_email_result"}
    end
  end

  def login_history
    authorize HbxProfile, :login_history?
    @user_login_history = SessionIdHistory.for_user(user_id: @user.id).order('created_at DESC').page(params[:page]).per(15)
  end

  # Auth not required
  def unsupported_browser; end

  private

  helper_method :user

  def email_update_params
    params.require(:user).permit(:email)
  end

  def validate_email
     @error = if params[:user][:email].blank?
               'Please enter a valid email'
             elsif params[:user].present? && !@user.update_attributes(email_update_params)
                @user.errors.full_messages.join.gsub('(optional) ', '')
              end
  end

  def user
    @user ||= User.find(params[:id])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
