class SitePagesController < ApplicationController
  require 'open-uri'

  before_action :authenticate_user!
  before_action :set_site_page, only: [:show, :edit, :edit_modal, :update, :destroy]

  # GET /site_pages
  # GET /site_pages.json
  def index
    @site_pages = SitePage.where("user_id = ?", current_user).paginate(page: params[:page], per_page: 5)
    @public_pages = SitePage.where("is_private = ?", false).paginate(page: params[:page], per_page: 5)
  end

  # GET /site_pages/1
  # GET /site_pages/1.json
  def show
    render layout: 'site_page'
  end


  # GET /site_pages/new
  def new
    @site_page = SitePage.new
  end

  def new_modal
    @site_page = SitePage.new
    render layout: 'site_page'
  end

  # GET /site_pages/1/edit
  def edit
  end
  def edit_modal
    render layout: 'site_page'
  end
  

  # POST /site_pages
  # POST /site_pages.json
  def create

    if params[:site_page][:target_url].empty?
      @site_url = root_url
    else
      url = params[:site_page][:target_url]
      pos = url.rindex('/')
      split_url = pos != nil ? [url[0..pos],url[pos+1..-1]] : [url]
      @site_url = split_url[0]
    end

    @site_page = current_user.site_pages.build(site_page_params) do |t|
      if !params[:site_page][:target_url].empty?
      #if params[:commit] == 'Copy Site'
        doc = Nokogiri::HTML(open(params[:site_page][:target_url],
              allow_redirections: :all,
              ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        t.content = SitePage.convert(doc.to_s, @site_url)
      else
        t.content = SitePage.convert(params[:site_page][:content], @site_url)
      end
    end

    respond_to do |format|
      if @site_page.save
        format.html { redirect_to site_pages_path, notice: 'Site page was successfully created.' }
        format.json { render json: { message: 'Site page was successfully created.'}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @site_page.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_pages/1
  # PATCH/PUT /site_pages/1.json
  def update
    respond_to do |format|
      if current_user.admin? || current_user.id == @site_page.user_id
        if @site_page.update(site_page_params)
          format.html { redirect_to site_pages_path, notice: 'Site page was successfully updated.' }
          format.json { render json: { message: 'Site page was successfully updated.' }, status: :ok }
        else
          format.html { render :edit }
          format.json { render json: @site_page.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /site_pages/1
  # DELETE /site_pages/1.json
  def destroy

    if current_user.admin? || current_user.id == @site_page.user_id
      @site_page.destroy
    end

    respond_to do |format|
      format.html { redirect_to site_pages_url, notice: 'Site page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def copy
    @site_page = SitePage.find(params[:id])
    @newt = SitePage.new
    @newt.id = nil
    @newt.title = Random.rand(11).to_s + '_' + current_user.id.to_s + '_' + @site_page.title
    @newt.description = @site_page.description
    @newt.content = @site_page.content
    @newt.is_private = true
    @newt.user_id = current_user.id
    # logger.debug @newt
    
      respond_to do |format|
        if @newt.save
          format.html { redirect_to site_pages_url,  :flash => { :success => "Phishing page was successfully copied." } }
          format.json { render json: { message: 'Phishing page was successfully copied.'}, status: :created }
        else
          format.html { redirect_to site_pages_url, :flash => { :error => @newt.errors.full_messages[0] } }
          format.json { render json: @newt.errors.full_messages, status: :unprocessable_entity }
        end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_page
      # @site_page = current_user.site_pages.find(params[:id])
      @site_page = SitePage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_page_params
      params.fetch(:site_page, {}).permit(:title, :description, :content, :is_private)
    end
end
