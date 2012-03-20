# encoding: UTF-8
class Administration::DocumentsController < ApplicationController

  before_filter :authorize_if_admin
  def get
    if current_user.is_admin?
      document = Document.find_by_id(params[:id])
      if document
        params[:vid] ||= -1
        # On récupère les numéros de version pourle document
        versions = document.get_versions
        # si le numéro de version passé en paramètre n'existe pas, on prend le plus grand
        version_number = (versions.include?(params[:vid].to_i) ? params[:vid].to_i : versions.max)
        document.revert_to(version_number)
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
      redirect_to new_administration_user_contract_document_path(@user,@contract)
    else
      redirect_to administration_user_contract_document_path(@user,@contract, @document)
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
      redirect_to new_administration_user_contract_document_path(@user,@contract)
    else
      redirect_to administration_user_contract_document_path(@user,@contract, @document)
    end
  end

  def destroy
    @user = User.find_by_id(params[:user_id])
    @document = Document.find(params[:id])
    if @document
      params[:vid] ||= -1
      # On récupère les numéros de version pourle document
      versions = @document.get_versions
      # 
      #
      # TODO : Penser au cas ou il n'y a qu'une seule version : détruire le rep parent.
      #
      #
      # si le numéro de version passé en paramètre n'existe pas, on prend le plus grand
      version_number = (versions.include?(params[:vid].to_i) ? params[:vid].to_i : versions.max)

      if @document.get_versions.size == 1 or @document.versions.empty? or @document.version == 1
        path = File.dirname(File.dirname(@document.uploaded_file.path))
        FileUtils.rm_rf path
        @document.destroy
        flash[:notice] = "Fichier supprimé avec succès"
      else
        version = @document.versions.find_by_number(version_number)
        @document.revert_to(version_number)
        path = File.dirname(@document.uploaded_file.path)
        @document.revert_to(@document.versions.last)

        @document.versions.find_by_number(version_number).destroy unless version.nil?
        FileUtils.rm_rf path
        flash[:notice] = "Fichier supprimé avec succès !"
      end
    else
      flash[:error] = "Impossible de supprimer le fichier."
    end

  respond_to do |format|
    format.html { redirect_to administration_user_path(@user) }
  end
end

end
