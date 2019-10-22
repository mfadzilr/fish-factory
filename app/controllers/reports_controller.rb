class ReportsController < ApplicationController
  before_action :set_report, only: [:export, :show, :edit, :edit_modal, :update, :destroy]

  # GET /reports
  # GET /reports.json

  def export
    respond_to do |format|
      format.xlsx do
        render xlsx: 'export',
        locals: { report: @report, action_type:  params[:type] },
        filename: "report-#{DateTime.now.to_i}"
      end
    end
  end

  def index
    @reports = current_user.reports.all.reorder("created_at DESC").paginate(page: params[:page], per_page: 5)
  end

  def new_modal
    @report = Report.new
    render layout: 'site_page'
  end
  def edit_modal
    render layout: 'site_page'
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  # GET /reports/1/edit
  def edit
  end
  def edit_modal
    render layout: 'site_page'
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = current_user.reports.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render json: { message: 'Report was successfully created.'}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render json: { message: 'Report was successfully updated.'}, status: :created }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = current_user.reports.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      # params.fetch(:report, {}).permit(:title, report_sources_attributes: [:report_id, :campaign_id])
      params.fetch(:report, {}).permit(:title, :campaign_ids => [])
    end
end
