# encoding: UTF-8
class DocumentsController < ApplicationController

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

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(params[:document])

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
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
