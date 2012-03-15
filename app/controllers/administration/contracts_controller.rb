# encoding: UTF-8
class Administration::ContractsController < ApplicationController
  before_filter :authorize_if_admin

  def index
    @contracts = Contract.all
  end

  def new
    @user = User.find_by_id(params[:user_id])
    @contract = Contract.new
  end

  def update
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.new(params[:contract])
    respond_to do |format|
      if @contract.update_attributes(params[:document])
        format.html { redirect_to administration_user_path(@user), notice: 'Le contrat a été modifié avec succès !' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def create
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.new(params[:contract])
    respond_to do |format|
      if @contract.save
        format.html { redirect_to administration_user_path(@user), notice: 'Le contrat a été crée avec succès !' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:id])
  end

  def show
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:id])
  end

  def destroy
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:id])
    @contract.destroy

    respond_to do |format|
      format.html { redirect_to administration_user_path(@user) }
      format.json { head :no_content }
    end
  end
end
