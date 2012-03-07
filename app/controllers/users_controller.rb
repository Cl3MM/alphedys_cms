# encoding: UTF-8
class UsersController < ApplicationController

  def index
    @users = User.find(:all)
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
#    unless authorize_if_admin
#      redirect_to root_url, :notice => "Vous devez avoir un compte pour accéder à cette page"
#    else
#      render "new"
#    end
  end

  def show
    @user = User.find(params[:id])
    session[:span] = 6 if current_user.is_admin?
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Votre compte à bien été créer !"
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to root_url, notice: "Votre profil a été mis à jour avec succès !"
    else
      render "edit"
    end
  end
end
