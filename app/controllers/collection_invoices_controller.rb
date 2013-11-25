class CollectionInvoicesController < ApplicationController
  # GET /collection_invoices
  # GET /collection_invoices.json
  def index
    @collection_invoices_grid = initialize_grid(CollectionInvoice)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collection_invoices_grid }
    end
  end

  # GET /collection_invoices/1
  # GET /collection_invoices/1.json
  def show
    @collection_invoice = CollectionInvoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collection_invoice }
    end
  end

  # GET /collection_invoices/new
  # GET /collection_invoices/new.json
  def new
    @collection_invoice = CollectionInvoice.new
    @collection_invoice.space = current_space

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collection_invoice }
    end
  end

  # GET /collection_invoices/1/edit
  def edit
    @collection_invoice = CollectionInvoice.find(params[:id])
  end

  # POST /collection_invoices
  # POST /collection_invoices.json
  def create
    @collection_invoice = CollectionInvoice.new(params[:collection_invoice])

    respond_to do |format|
      if @collection_invoice.save
        format.html { redirect_to collection_invoices_path, notice: 'Collection invoice was successfully created.' }
        format.json { render json: @collection_invoice, status: :created, location: @collection_invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @collection_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collection_invoices/1
  # PATCH/PUT /collection_invoices/1.json
  def update
    @collection_invoice = CollectionInvoice.find(params[:id])

    respond_to do |format|
      if @collection_invoice.update_attributes(params[:collection_invoice])
        format.html { redirect_to collection_invoices_path, notice: 'Collection invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collection_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collection_invoices/1
  # DELETE /collection_invoices/1.json
  def destroy
    @collection_invoice = CollectionInvoice.find(params[:id])
    @collection_invoice.destroy

    respond_to do |format|
      format.html { redirect_to collection_invoices_url }
      format.json { head :no_content }
    end
  end
end
