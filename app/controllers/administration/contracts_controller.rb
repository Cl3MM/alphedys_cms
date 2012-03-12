class Administration::ContractsController < ApplicationController
  before_filter :authorize_if_admin

  def new
    @user = User.find_by_id(params[:user_id])
    @contract = Contract.new
  end

  def create
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.new(params[:contract])
    respond_to do |format|
      if @contract.save
        format.html { redirect_to administration_user_path(@user), notice: 'Contract was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
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
