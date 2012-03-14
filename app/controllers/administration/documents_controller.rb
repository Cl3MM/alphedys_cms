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
    doc = Document.new(params[:document])
    if doc.uploaded_file_file_size == @document.uploaded_file_file_size
      flash[:error] = "La taille du nouveau fichier est la même que celle de l'ancien."
    else
      @document.version
      if @document.update_attributes(params[:document])
        @document.versions.last.update_attribute(:user_id, current_user)
        flash[:notice] = "Le fichier #{@document.file_name} a bien été mis à jour !"
      end
    end
    redirect_to administration_user_contract_document_path(@user,@contract, @document)
  end

  def new
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.new
  end

  def create
    @user = User.find_by_id(params[:user_id])
    @contract = @user.contracts.find_by_id(params[:contract_id])
    if params[:document].nil?
      flash[:error] = "Vous devez sélectionner un fichier !"
    else
      docs =  @contract.documents
      doc = Document.new(params[:document])
      # si fichier déja présent dans le contrat de l'utilisateur
      if docs.map {|x| x.file_name}.include? doc.file_name
        # on met à jour le document existant avec une nouvelle version
        @document = docs.find_by_uploaded_file_file_name(doc.file_name)
        #binding.pry
        if doc.uploaded_file_file_size == @document.uploaded_file_file_size
          flash[:error] = "La taille du nouveau fichier est la même que celle de l'ancien."
        else
          @document.version
          @document.update_attributes(params[:document])
          @document.versions.last.update_attribute(:user_id, current_user)
          flash[:notice] = "Le fichier #{@document.file_name} a été mis à jour avec succès !"
        end
      # sinon on crée un nouveau document
      else
        @document = docs.new(params[:document])
        @document.version
        if @document.save
          flash[:notice] = "Le fichier #{@document.file_name} a été ajouté avec succès !"
        end
      end
    end
    if flash[:error]
      redirect_to new_administration_user_contract_document_path(@user,@contract, @document)
    else
      redirect_to administration_user_contract_document_path(@user,@contract, @document)
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
