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
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Votre compte a bien été crée !"
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
