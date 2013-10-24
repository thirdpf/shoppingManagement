class ShoppingManagementDevelopmentsController < ApplicationController
  before_action :set_shopping_management_development, only: [:show, :edit, :update, :destroy]

#  def menu
#  end

  # 検索画面表示
  def searchInit
    @category = Category.find(:all)
    render :action => 'search.html.erb'
  end

  # 検索結果表示画面
  def search
    ## 検索画面からきたかどうかをparamsがNULLかどうかで切り分け
    if params[:goods].present?
    else
      #検索画面から渡ってきた条件をクラス変数に格納
      @categorytmp = params[:page]
      @@category = @categorytmp[:categorycd]
      
      @@goods = params[:goods]
    end

    #end
    
    # 検索条件 動的SQL作成
    # ～ 購入TBLと消費TBLから在庫数を算出する
    @sqlcode =
     "SELECT s.categoryCd , s.goods, buynum - shohinum as zaiko \
      FROM \
      ( \
       SELECT categoryCd, goods, SUM(sum) buynum \
       FROM shoppingmanagement_development.shopping_management_developments \
       WHERE categoryCd = ? AND goods like ? \
       GROUP BY categoryCd, goods \
      ) b ,\
      ( \
       SELECT categoryCd, goods, SUM(shohisum) shohinum \
       FROM shoppingmanagement_development.shohis \
       WHERE categoryCd = ? AND goods like ? \
       GROUP BY categoryCd, goods \
      ) s
      WHERE b.categoryCd = s.categoryCd
      AND   b.goods      = s.goods ;"


    puts "****************************************************"
    puts "カテゴリコード: #{@@category}"
    puts "商品名        : #{@@goods}"
    puts "SQL(bi mae)   : #{@sqlcode}"
    puts "****************************************************"

    #@sqlbind1 = "categoryCd = " 
    #@sqlbind2 = "goods      like "

    case
    when @@category.blank? && @@goods.blank?
        puts "ERROR: カテゴリ または 商品名 どちらかを入力して検索してください"
    when @@category.blank? || @@goods.blank?
      if @@category.blank?
           ## 商品名で検索 ##
           puts "カテゴリがNULLです"
           # カテゴリの条件を削除(置換)
           @sqlcode = @sqlcode.gsub("categoryCd = ? AND","")
           @results = ShoppingManagementDevelopment.find_by_sql([@sqlcode ,@@goods ,@@goods])
      elsif @@goods.blank?
           ## カテゴリで検索 ##
           puts "商品名がNULLです"
           @results = ShoppingManagementDevelopment.find_by_sql([@sqlcode , @@category ,"%", @@category ,"%"])
      end
    else 
      ## カテゴリ および 商品名で検索 ##
      puts "どちらもNULLでない"
           @results = ShoppingManagementDevelopment.find_by_sql([@sqlcode , @@category ,@@goods , @@category ,@@goods])
    end
    
    
    #@results = ShoppingManagementDevelopment.find_by_sql(["SELECT * FROM shopping_management_developments WHERE goods LIKE ? and categoryCd = ?", "%#{@@goods}%","#{@@category}"])

     ## 想定SQL
     # SELECT s.categoryCd , s.goods, buynum - shohinum as zaiko
     # FROM
     # (
     #  SELECT categoryCd, goods, SUM(sum) buynum
     #  FROM shoppingmanagement_development.shopping_management_developments
     #  WHERE categoryCd = :categorycode 
     #    AND goods like :goods
     #  GROUP BY categoryCd, goods
     # ) b,
     # (
     #  SELECT categoryCd, goods, SUM(shohisum) shohinum
     #  FROM shoppingmanagement_development.shohis
     #  WHERE categoryCd = :categorycode 
     #    AND goods like = :goods
     #  GROUP BY categoryCd, goods
     # ) s
     # WHERE b.categoryCd = s.categoryCd
     # AND   b.goods      = s.goods ;"

    render :action => 'searchResult.html.erb'
     
  end

  def createShohi
    time = Time.now
    puts "####################createshohi###################"
    puts "カテゴリ   : #{params[:category]}"
    puts "商品名     : #{params[:goods]}"
    puts "消費入力数 : #{params[:shohi]}"
    puts time
    puts "検索条件(カテゴリ) : #{@@category}"
    puts "検索条件(商品名)   : #{@@goods}"
    puts "####################createshohi###################"
    
    @shohimodel = Shohi.new(:categoryCd => params[:category] , :goods => params[:goods] , :shohiSum => params[:shohi] , :shohiDate => time )
    if @shohimodel.save
      puts "消費数を反映しました"
    else
      puts "処理に失敗しました"
    end
    
    #render :text => '更新しました' #, :action => 'searchResult.html.erb'
    search()
  end

  # 購入履歴一覧画面表示
  def searchHistory
   puts "####################searchHistory###################"
   puts "カテゴリ: #{params[:category]}"
   puts "商品名  : #{params[:goods]}"
   puts "####################searchHistory###################"

#テスト用Dummy
#    @shopping_management_developments = ShoppingManagementDevelopment.all
#    @history =  ActiveRecord::Base.connection.select("SELECT goods AS viewGoods, place AS viewPlace, 'test' AS viewStatus FROM shopping_management_developments")

    @sqlcode =
    "SELECT TMP.id, TMP.categoryCd, C.categoryname, TMP.viewGoods, TMP.viewDate, TMP.viewAmount, TMP.viewSum, TMP.viewPlace, TMP.viewStatus, '' AS delSt \
     FROM \
     ( SELECT A.id, A.categoryCd, A.goods AS viewGoods, A. DATE AS viewDate, A.amount AS viewAmount, A. SUM AS viewSum, A.place AS viewPlace, '購入' AS viewStatus \
       FROM shopping_management_developments A \
       WHERE A.categoryCd = ? AND A.goods = ? \
         UNION \
       SELECT B.id, B.categoryCd, B.goods, B.shohiDate AS viewDate, '' AS viewAmount, B.shohiSum AS viewSum, '' AS viewPlace, '消費' AS viewStatus \
       FROM shohis B WHERE B.categoryCd = ? AND B.goods = ? \
     ) TMP \
     INNER JOIN categories C ON (TMP.categoryCd = C.categorycd) ORDER BY TMP.viewDate desc;"

    @history = ShoppingManagementDevelopment.find_by_sql([@sqlcode, "#{params[:category]}", "#{params[:goods]}", "#{params[:category]}", "#{params[:goods]}"])

#     @history =  ActiveRecord::Base.connection.select("SELECT TMP.id,TMP.categoryCd,C.categoryname,TMP.viewGoods,TMP.viewDate,TMP.viewAmount,TMP.viewSum,TMP.viewPlace,TMP.viewStatus,'' AS delSt FROM (SELECT A.id,A.categoryCd,A.goods AS viewGoods,A. DATE AS viewDate,A.amount AS viewAmount,A. SUM AS viewSum,A.place AS viewPlace,'購入' AS viewStatus FROM shopping_management_developments A WHERE A.categoryCd = '1001' AND A.goods ='雑貨１' UNION SELECT B.id,B.categoryCd,B.goods,B.shohiDate AS viewDate,'' AS viewAmount,B.shohiSum AS viewSum,'' AS viewPlace,'消費' AS viewStatus FROM shohis B WHERE B.categoryCd = '1001' AND B.goods = '雑貨１') TMP INNER JOIN categories C ON (TMP.categoryCd = C.categorycd) ORDER BY TMP.viewDate desc")
#       SELECT
#        TMP.id
#        ,TMP.categoryCd
#        ,C.categoryname
#        ,TMP.viewGoods
#        ,TMP.viewDate
#        ,TMP.viewAmount
#        ,TMP.viewSum
#        ,TMP.viewPlace
#        ,TMP.viewStatus
#    FROM
#    (
#      SELECT
#          A.id
#          ,A.categoryCd
#          ,A.goods AS viewGoods
#          ,A. DATE AS viewDate
#          ,A.amount AS viewAmount
#          ,A. SUM AS viewSum
#          ,A.place AS viewPlace
#          ,'購入' AS viewStatus
#        FROM
#          shopping_management_developments A
#        WHERE
#          A.categoryCd = '1001'
#          AND A.goods = '雑貨１'
#      UNION
#      SELECT
#          B.id
#          ,B.categoryCd
#          ,B.goods
#          ,B.shohiDate AS viewDate
#          ,'' AS viewAmount
#          ,B.shohiSum AS viewSum
#          ,'' AS viewPlace
#          ,'消費' AS viewStatus
#        FROM
#          shohis B
#        WHERE
#          B.categoryCd = '1001'
#          AND B.goods = '雑貨１'
#    ) TMP INNER JOIN categories C ON (
#      TMP.categoryCd = C.categorycd
#    )
#    ORDER BY
#      TMP.viewDate
#    ")

    render :action => 'history.html.erb'
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
