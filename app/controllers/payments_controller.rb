class PaymentsController < ApplicationController
  # GET /payments
  # GET /payments.json
  def index
    @payments_grid = initialize_grid(Payment)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments_grid }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new
    @project = Project.find params[:project_id]
    @payment.project = @project
    @payment.client_id = @project.client_id
    @payment.space = current_space

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payments_path, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to payments_path, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end

  def assign_invoice
    @payment = Payment.find params[:id]
  end

  def save_invoice_assignment
    @payment = Payment.find params[:id]
    if request.post?
      @payment.update_attributes!(params[:payment])
      respond_to do |format|
        format.html { redirect_to payments_path, notice: '发票绑定完毕'}
      end
    end
  end
end
