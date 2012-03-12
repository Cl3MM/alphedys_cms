# encoding: UTF-8
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

  def show
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.find_by_id(params[:id])

    @document.version

    if @document.update_attributes(params[:document])
      @document.versions.last.update_attribute(:user_id, current_user)
      redirect_to administration_user_contract_document_path(@user,@contract, @document), :notice => "Le fichier #{@document.file_name} a bien été mis à jour !"
    else
      render [:administration, :user, :contract, @document], :notice => "Un problème est advenu lors de la mise à jour du fichier."
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
    @document.version
    if @document.save
#      @document.versions.last.update_attribute(:user_id, current_user)
      redirect_to administration_user_contract_document_path(@user,@contract, @document), :notice => "Le fichier #{@document.file_name} a été ajouté avec succès !"
    else
      render :partial => "/administration/documents", :locals => { :user => @user, :contract => @contract, :document => @document}
    end
  end

  def destroy
    @user = User.find_by_id(params[:user_id])

    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to administration_user_path(@user), :notice => "Le fichier a été supprimé avec succès !" }
    end
  end

end
