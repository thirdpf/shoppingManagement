class ShoppingManagementDevelopmentsController < ApplicationController
  before_action :set_shopping_management_development, only: [:show, :edit, :update, :destroy]

#  def menu
#  end

  # 検索画面表示
  def searchInit
    @category = Category.select("categoryname")
    #@categories = Category.find_by_categorycd(:all)
    render :action => 'search.html.erb'
  end

  # 検索結果表示画面表示
  def search
    @results = ShoppingManagementDevelopment.find(:all, 
                           :conditions => ["goods like ?" ,"%#{params[:goods]}%"])
    render :action => 'searchResult.html.erb'
  end

  # GET /shopping_management_developments
  # GET /shopping_management_developments.json
  def index
    @shopping_management_developments = ShoppingManagementDevelopment.all
  end

  # GET /shopping_management_developments/1
  # GET /shopping_management_developments/1.json
  def show
  end

  # GET /shopping_management_developments/new
  def new
    @shopping_management_development = ShoppingManagementDevelopment.new
  end

  # GET /shopping_management_developments/1/edit
  def edit
  end

  # POST /shopping_management_developments
  # POST /shopping_management_developments.json
  def create
    # newでインスタンスを作成
    @shopping_management_development = ShoppingManagementDevelopment.new(shopping_management_development_params)

    respond_to do |format|
      if @shopping_management_development.save
        format.html { redirect_to @shopping_management_development, notice: 'Shopping management development was successfully created.' }
        format.json { render action: 'show', status: :created, location: @shopping_management_development }
      else
        format.html { render action: 'new' }
        format.json { render json: @shopping_management_development.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_management_developments/1
  # PATCH/PUT /shopping_management_developments/1.json
  def update
    respond_to do |format|
      if @shopping_management_development.update(shopping_management_development_params)
        format.html { redirect_to @shopping_management_development, notice: 'Shopping management development was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shopping_management_development.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_management_developments/1
  # DELETE /shopping_management_developments/1.json
  def destroy
    @shopping_management_development.destroy
    respond_to do |format|
      format.html { redirect_to shopping_management_developments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_management_development
      @shopping_management_development = ShoppingManagementDevelopment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shopping_management_development_params
      params.require(:shopping_management_development).permit(:categoryCd, :goods, :date, :amount, :sum, :place)
    end
end
