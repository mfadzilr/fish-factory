class AttachmentFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment_file, only: [:show, :edit, :update, :destroy]

  # GET /attachment_files
  # GET /attachment_files.json
  def index
    @attachment_files = AttachmentFile.all
  end

  # GET /attachment_files/1
  # GET /attachment_files/1.json
  def show
  end

  # GET /attachment_files/new
  def new
    @attachment_file = AttachmentFile.new
  end

  # GET /attachment_files/1/edit
  def edit
  end

  # POST /attachment_files
  # POST /attachment_files.json
  def create
    @attachment_file = AttachmentFile.new(attachment_file_params)

    respond_to do |format|
      if @attachment_file.save
        format.html { redirect_to @attachment_file, notice: 'Attachment file was successfully created.' }
        format.json { render :show, status: :created, location: @attachment_file }
      else
        format.html { render :new }
        format.json { render json: @attachment_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachment_files/1
  # PATCH/PUT /attachment_files/1.json
  def update
    respond_to do |format|
      if @attachment_file.update(attachment_file_params)
        format.html { redirect_to @attachment_file, notice: 'Attachment file was successfully updated.' }
        format.json { render :show, status: :ok, location: @attachment_file }
      else
        format.html { render :edit }
        format.json { render json: @attachment_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachment_files/1
  # DELETE /attachment_files/1.json
  def destroy
    @attachment_file.destroy
    respond_to do |format|
      format.html { redirect_to attachment_files_url, notice: 'Attachment file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment_file
      @attachment_file = AttachmentFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_file_params
      params.require(:attachment_file).permit(:name, :description, :payload)
    end
end
