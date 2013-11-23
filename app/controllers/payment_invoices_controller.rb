class PaymentInvoicesController < ApplicationController
  # GET /payment_invoices
  # GET /payment_invoices.json
  def index
    @payment_invoices_grid = initialize_grid(PaymentInvoice)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_invoices_grid }
    end
  end

  # GET /payment_invoices/1
  # GET /payment_invoices/1.json
  def show
    @payment_invoice = PaymentInvoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_invoice }
    end
  end

  # GET /payment_invoices/new
  # GET /payment_invoices/new.json
  def new
    @payment_invoice = PaymentInvoice.new
    @payment_invoice.space = current_space

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_invoice }
    end
  end

  # GET /payment_invoices/1/edit
  def edit
    @payment_invoice = PaymentInvoice.find(params[:id])
  end

  # POST /payment_invoices
  # POST /payment_invoices.json
  def create
    @payment_invoice = PaymentInvoice.new(params[:payment_invoice])

    respond_to do |format|
      if @payment_invoice.save
        format.html { redirect_to payment_invoices_path, notice: 'Payment invoice was successfully created.' }
        format.json { render json: @payment_invoice, status: :created, location: @payment_invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_invoices/1
  # PATCH/PUT /payment_invoices/1.json
  def update
    @payment_invoice = PaymentInvoice.find(params[:id])

    respond_to do |format|
      if @payment_invoice.update_attributes(params[:payment_invoice])
        format.html { redirect_to payment_invoices_path, notice: 'Payment invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_invoices/1
  # DELETE /payment_invoices/1.json
  def destroy
    @payment_invoice = PaymentInvoice.find(params[:id])
    @payment_invoice.destroy

    respond_to do |format|
      format.html { redirect_to payment_invoices_url }
      format.json { head :no_content }
    end
  end
end
