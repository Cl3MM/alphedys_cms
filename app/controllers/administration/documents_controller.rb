class Administration::DocumentsController < ApplicationController

  before_filter :authorize_if_admin
  def get
    if current_user.is_admin?
      document = Document.find_by_id(params[:id])
      if document
        send_file document.uploaded_file.path, :type => document.uploaded_file_content_type
      end
    end
  end

  def new
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.new
  end

  def create
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.new(params[:document])
    if @document.save
      redirect_to administration_user_contract_path(@user,@contract), :notice => "File #{@document.file_name} uploaded !"
    else
      render @document
    end
  end

  def destroy
    @user = User.find_by_id(params[:user_id])

    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to administration_user_path(@user), :notice => "Delete complete" }
    end
  end

end
