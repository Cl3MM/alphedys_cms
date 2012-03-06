class Administration::UsersController < ApplicationController
  before_filter :authorize_if_admin

  def new
    @user = User.new
  end
  def index
    @users = User.find(:all)
  end
  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to administration_users_url, :notice => "User #{@user.name_tag} has been created!"
    else
      render new_administration_user_path(@user)
    end
  end
  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to administration_users_url }
    end
  end

end
