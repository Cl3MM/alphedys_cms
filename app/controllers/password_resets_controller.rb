# encoding: UTF-8
class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => "Un email contenant les instructions pour réinitialiser votre mot de passe a été envoyé à votre adresse."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Le lien de réinitialisation a expiré, merci de recommencer l'opération."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Votre mot de passe à bien été changé !"
    else
      render :edit
    end
  end
end
