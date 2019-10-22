class RecipientGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient_group, only: [:show, :edit, :edit_modal, :update, :destroy]

  # GET /recipient_groups
  # GET /recipient_groups.json
  def index
    # @recipient_groups = RecipientGroup.all
    @recipient_groups = current_user.recipient_groups.paginate(page: params[:page], per_page: 5)
  end

  # GET /recipient_groups/1
  # GET /recipient_groups/1.json
  def show
  end

  # GET /recipient_groups/new
  def new
    @recipient_group = RecipientGroup.new
  end

  def new_modal
    @recipient_group = RecipientGroup.new
    render layout: 'site_page'
  end

  # GET /recipient_groups/1/edit
  def edit
  end
  def edit_modal
    render layout: 'site_page'
  end

  # POST /recipient_groups
  # POST /recipient_groups.json
  def create
    @recipient_group = current_user.recipient_groups.build(recipient_group_params) do |t|
      if params[:recipient_group][:data]
        t.data      = params[:recipient_group][:data].read
        t.filename  = params[:recipient_group][:data].original_filename
        t.mime_type = params[:recipient_group][:data].content_type
      end
    end

    respond_to do |format|
      if @recipient_group.save
        RecipientGroup.import(params[:recipient_group][:data], @recipient_group)
        format.html { redirect_to recipient_groups_path, notice: 'Recipient group was successfully created.' }
        format.json { render json: { message: 'New recipient group successfully created.'}, status: :created }
      else
        flash[:error] =  @recipient_group.errors.full_messages[0];
        format.html { redirect_to recipient_groups_path }
        format.json { render json: @recipient_group.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /recipient_groups/1
  # PATCH/PUT /recipient_groups/1.json
  def update
    respond_to do |format|
      if @recipient_group.update(recipient_group_params)
        format.html { redirect_to recipient_groups_path, notice: 'Recipient group was successfully updated.' }
        format.json { render json: { message: 'Recipient group successfully saved.'}, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @recipient_group.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_groups/1
  # DELETE /recipient_groups/1.json
  def destroy
    @recipient_group.destroy
    respond_to do |format|
      format.html { redirect_to recipient_groups_path, notice: 'Recipient group was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipient_group
      # @recipient_group = RecipientGroup.find(params[:id])
      @recipient_group = current_user.recipient_groups.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipient_group_params
      params.fetch(:recipient_group, {}).permit(:name, :description, :data)
    end
end
