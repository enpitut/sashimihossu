require 'mail'

class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new#(item_params)

    # upload_file = image_params[:file]
    # image = {}
    # if upload_file != nil
    #   image[:filename] = upload_file.original_filename
    #   image[:file] = upload_file.read
    # end
    # @image = Image.new(image)
    # if @image.save
    #   flash[:success] = "画像を保存しました。"
    #   # redirect_to @image
    # else
    #   flash[:error] = "保存できませんでした。"
    # end

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # テキストファイルに落としたメールを扱いやすい形に
  def self.recvmail(now_date)
      mail = Mail.read("app/controllers/tmp/#{now_date}_mail.txt")

      puts [mail.envelope_from, mail.body.decoded]
      #return [mail.envelope_from, mail.body.encoded]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :amount_at_a_time, :gram_at_a_time, :price_at_a_time, :price_at_one_amount, :price_at_one_gram, :description, :icon)
    end


    def image_params
      params.require(:image).permit(
          :filename,:file
      )
    end
end
