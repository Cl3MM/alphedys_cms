# encoding: UTF-8
class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to current_user
    end
  end

  def index
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.is_admin?
        session[:span] = 8
        redirect_to administration_users_url, notice: "Bienvenue #{user.name_tag} !"
      else
        redirect_to user, notice: "Bienvenue #{user.name_tag} !"
      end
    else
      flash.now.alert = "Email ou mot de passe invalide"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Vous êtes maintenant déconnecté !"
  end
end
