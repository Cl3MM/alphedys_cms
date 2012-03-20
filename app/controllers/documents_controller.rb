# encoding: UTF-8
class DocumentsController < ApplicationController

  before_filter :authorize

  before_filter :authorize_if_admin, :only => [:destroy]

  def get
    document = Document.find_by_id(params[:id])
    if document and current_user.user_document_ids.include? document.id
      params[:vid] ||= -1
      # On récupère les numéros de version pourle document
      versions = (document.versions.map{|n| n.number} << 1).map{|c| c.to_s}
      # si le numéro de version passé en paramètre n'existe pas, on prend le plus grand
      version_number = (versions.include?(params[:vid]) ? params[:vid] : versions.max)
      document.revert_to(version_number.to_i)
      send_file document.uploaded_file.path, :type => document.uploaded_file_content_type
    else
      redirect_to root_url, :alert => "Le fichier n'existe pas ou ne vous appartient pas."
    end
  end

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @contract = current_user.contracts.find_by_id(params[:contract_id])
    @document = @contract.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @contract = current_user.contracts.find_by_id(params[:contract_id])
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @contract = current_user.contracts.find_by_id(params[:contract_id])
    @document = Document.find(params[:id])
  end

  def create
    @user = current_user
    @contract = @user.contracts.find_by_id(params[:contract_id])
    if params[:document][:uploaded_file].nil?
      flash[:error] = "Vous devez sélectionner un fichier !"
    else
      docs =  @contract.documents
      doc = Document.new(params[:document])
      # si fichier déja présent dans le contrat de l'utilisateur
      if docs.map {|x| x.file_name}.include? doc.file_name
        # on met à jour le document existant avec une nouvelle version
        @document = docs.find_by_uploaded_file_file_name(doc.file_name)
        if doc.uploaded_file_file_size == @document.uploaded_file_file_size
          flash[:error] = "Un fichier portant le même nom et de taille similaire existe déjà."
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
      redirect_to new_user_contract_document_path(@user,@contract)
    else
      redirect_to user_contract_document_path(@user,@contract, @document)
    end
  end

  def update
    @user = current_user
    @contract = @user.contracts.find_by_id(params[:contract_id])
    if params[:document][:uploaded_file].nil?
      flash[:error] = "Vous devez sélectionner un fichier !"
    else
      docs =  @contract.documents
      doc = Document.new(params[:document])
      # si fichier déja présent dans le contrat de l'utilisateur
      if docs.map {|x| x.file_name}.include? doc.file_name
        # on met à jour le document existant avec une nouvelle version
        @document = docs.find_by_uploaded_file_file_name(doc.file_name)
        if doc.uploaded_file_file_size == @document.uploaded_file_file_size
          flash[:error] = "Un fichier portant le même nom et de taille similaire existe déjà."
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
      redirect_to administration_user_contract_document_path(@user,@contract)
    else
      redirect_to user_contract_document_path(@user,@contract, @document)
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
