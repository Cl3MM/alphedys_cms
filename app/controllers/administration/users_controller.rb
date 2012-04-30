# encoding: UTF-8
class Administration::UsersController < ApplicationController
  before_filter :authorize_if_admin

  def new
    @user = User.new
  end
  def index
    @users = User.find(:all, :order => :company)
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    #binding.pry
    respond_to do |format|
      format.html {
        if @user.update_attributes(params[:user])
          redirect_to administration_user_url(@user), :notice => "Les informations de l'utilisateur #{@user.name_tag} ont été modifiées !"
        else
          render "edit", :alert => "Une erreur est survenue lors de la mise à jour de l'utilisateur #{@user.name_tag}."
        end
      }
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to administration_users_url, :notice => "L'utilisateur #{@user.name_tag} a bien été créé !"
    else
      render new_administration_user_path(@user), :alert => "Une erreur est survenue lors de la création de l'utilisateur #{@user.name_tag}. Merci de recommencer."
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    name = @user.name_tag
    @user.destroy

    respond_to do |format|
      format.html { redirect_to administration_users_url, :notice => "L'utilisateur #{name} a été supprimé avec succès !" }
    end
  end

end
