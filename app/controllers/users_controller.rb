# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :authorize_if_admin, :only => [:create]

  before_filter :authorize

  def index
    @users = User.find(:all)
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def show
    flash.keep
    #@user = User.find(params[:id])
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Le compte utilisateur #{@user.name_tag} a bien été crée !"
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user), notice: "Votre profil a été mis à jour avec succès !"
    else
      render "edit"
    end
  end
end
