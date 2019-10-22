class EmailTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email_template, only: [:show, :edit, :edit_modal, :update, :destroy]

  # GET /email_templates
  # GET /email_templates.json
  def index
    # @email_templates = current_user.email_templates
    @email_templates = EmailTemplate.where("user_id = ?", current_user).paginate(page: params[:page], per_page: 5)
    @public_templates = EmailTemplate.where("is_private = ? AND user_id <> ?", false, current_user).paginate(page: params[:page], per_page: 5)
    # @email_templates = EmailTemplate.paginate(page: params[:page], per_page: 5)
  end

  # GET /email_templates/1
  # GET /email_templates/1.json
  def show
    render layout: 'site_page'
  end

  # GET /email_templates/new
  def new
    @email_template = EmailTemplate.new
  end
  def new_modal
    @email_template = EmailTemplate.new
    render layout: 'site_page'
  end

  # GET /email_templates/1/edit
  def edit
    # render layout: 'site_page'
  end
  def edit_modal
    render layout: 'site_page'
  end

  # POST /email_templates
  # POST /email_templates.json
  def create
    # @user = current_user
    @email_template = current_user.email_templates.build(email_template_params)

    respond_to do |format|
      if @email_template.save
        format.html { redirect_to @email_template, notice: 'Email template was successfully created.' }
        format.json { render json: { message: 'Email template was successfully created.'}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @email_template.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_templates/1
  # PATCH/PUT /email_templates/1.json
  def update
    respond_to do |format|
      if current_user.admin? || current_user.id == @email_template.user_id
        if @email_template.update(email_template_params)
          format.html { redirect_to @email_template, notice: 'Email template was successfully updated.' }
          format.json { render json: { message: 'Email template was successfully updated.'} , status: :ok }
        else
          format.html { render :edit }
          format.json { render json: @email_template.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @email_template.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_templates/1
  # DELETE /email_templates/1.json
  def destroy
    if current_user.admin? || current_user.id == @email_template.user_id
      @email_template.destroy
    end

    respond_to do |format|
      format.html { redirect_to email_templates_url, notice: 'Email template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def copy
    @email_template = EmailTemplate.find(params[:id])
    @newt = EmailTemplate.new
    @newt.id = nil
    @newt.title = Random.rand(11).to_s + '_' + current_user.id.to_s + '_' + @email_template.title
    @newt.description = @email_template.description
    @newt.content = @email_template.content
    @newt.is_private = true
    @newt.user_id = current_user.id
    # logger.debug @newt
    
      respond_to do |format|
        if @newt.save
          format.html { redirect_to email_templates_url,  :flash => { :success => "Email template was successfully copied." } }
          format.json { render json: { message: 'Email template was successfully copied.'}, status: :created }
        else
          format.html { redirect_to email_templates_url, :flash => { :error => @newt.errors.full_messages[0] } }
          format.json { render json: @newt.errors.full_messages, status: :unprocessable_entity }
        end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      # @email_template = EmailTemplate.find(params[:id])
      @email_template = EmailTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_template_params
      params.fetch(:email_template, {}).permit(:title, :description, :content, :is_private)
    end
end
