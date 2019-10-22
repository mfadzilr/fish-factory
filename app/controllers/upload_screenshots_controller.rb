class UploadScreenshotsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_upload_screenshot, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :exception, prepend: true, except: [:new, :create]

  # GET /upload_screenshots
  # GET /upload_screenshots.json
  def index
    @upload_screenshots = UploadScreenshot.all
  end

  # GET /upload_screenshots/1
  # GET /upload_screenshots/1.json
  def show
  end

  # GET /upload_screenshots/new
  def new
    @upload_screenshot = UploadScreenshot.new
  end

  # GET /upload_screenshots/1/edit
  def edit
  end

  # POST /upload_screenshots
  # POST /upload_screenshots.json
  def create
    @upload_screenshot = UploadScreenshot.new(upload_screenshot_params) do |t|
      t.origin = request.remote_ip
    end

    respond_to do |format|
      if @upload_screenshot.save
        format.html { redirect_to @upload_screenshot, notice: 'Upload screenshot was successfully created.' }
        format.json { render :show, status: :created, location: @upload_screenshot }
      else
        format.html { render :new }
        format.json { render json: @upload_screenshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /upload_screenshots/1
  # PATCH/PUT /upload_screenshots/1.json
  def update
    respond_to do |format|
      if @upload_screenshot.update(upload_screenshot_params)
        format.html { redirect_to @upload_screenshot, notice: 'Upload screenshot was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload_screenshot }
      else
        format.html { render :edit }
        format.json { render json: @upload_screenshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /upload_screenshots/1
  # DELETE /upload_screenshots/1.json
  def destroy
    @upload_screenshot.destroy
    respond_to do |format|
      format.html { redirect_to upload_screenshots_url, notice: 'Upload screenshot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload_screenshot
      @upload_screenshot = UploadScreenshot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_screenshot_params
      params.require(:upload_screenshot).permit(:image)
    end
end
