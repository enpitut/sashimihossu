class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.js 部分テンプレートを呼び出したいときはこちら
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.js # show.js.erb が実行される
      format.json { render :show, status: :ok, location: @item }
    end
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    # editでは，他のアクションと同じようにeditページに遷移するとき以下のレンダリング処理が発生する．
    # editページでsubmitが押されたときのアクションはupdateである．
    respond_to do |format|
      format.html { render :show }
      format.js # edit.js.erb が実行される．link_to で :remote => true の場合はこれになる
      format.json { render :show, status: :ok, location: @item }
    end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new#(item_params)

    # jsonとして渡ってきたパラメターをパースして，新規作成したitemに設定
    @item.title = params['item']['title']
    @item.user_id = params['item']['user_id']
    @item.start = params['item']['start']
    @item.end = params['item']['end']
    @item.allDay = params['item']['all_day']

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
        # format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.html { redirect_to @item }
        format.json { render :show, status: :created, location: @item }
        #format.html { redirect_to edit_item_path(@item.id) }
        #format.json { redirect_to edit_item_path(@item.id) }
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
        # format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.html { redirect_to @item }
        format.js # update.js.erb が実行される．submit で :remote => true の場合はこれになる
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
      # format.html { redirect_to index_url, notice: 'Item was successfully destroyed.' }
      format.html { redirect_to index_url }
      format.js # destroy.js.erb が実行される．link_to で :remote => true の場合はこれになる
      format.json { head :no_content }
    end
  end


  #=================================================================================================================================================
  # ユーザidにもとづいて所持商品一覧を取得してjsonで返す．fullcalender用
  # GET /items/index_by_user.json
  def index_by_user
    # current_user は現在ログインしているUserオブジェクトを返すdeviseのHelperメソッド
    @items = Item.where(:user_id => current_user.id);
    respond_to do |format|
      # 拡張子がjsonで来た場合のみ応答
      format.json { render :json => @items }
    end
    # 拡張子で何が来ようが拡張子が無かろうがjsonで返す
    # render :json => @items
  end

  # 現在ログインしているユーザのidを返す．
  # current_userメソッドは，deviseが提供している現在のユーザ情報を返すヘルパメソッド
  # GET /items/current_user_id
  def current_user_id
    respond_to do |format|
      # 拡張子がjsonで来た場合のみ応答
      format.json { render :json => current_user.id }
    end
  end

  def show_recipes
    array = Array.new
    # 複数渡せるようにarrayにしているが，フロントが複数選択に未対応のためとりあえず1個だけクエリを渡す．
    array << params[:name]
    @recipes = acquire_recommended_recipes(array);
    #puts @recipes
    respond_to do |format|
      format.js # show_recipes.js.erb が実行される
    end
  end


  #=================================================================================================================================================
  # テキストファイルに落としたメールをパースしてデータを登録
  def recvmail(now_date)
    #mail = Mail.read("app/controllers/tmp/#{now_date}_mail.txt")
    #puts [mail.envelope_from, mail.body.decoded]

    begin
      # 検索用正規表現を準備
      reg1=/.?商品名称.?[\s]*(.+)[\s]([0-9]+.*)/
      reg2=/.*数量.?([0-9]+).*/
      reg3=/.*注文者.?[\s]*(.+)[\s]+様/

      # ファイルを取得
      # df="./tmp/mail.txt"
      df="./tmp/#{now_date}_mail.txt"
      file=File.new(df)

      # 全データを入れるハッシュを作成
      #if file
      @parsed_items = Hash.new
      # ファイルをパース
      while line=file.gets
        # 注文者を取得
        # if line.force_encoding("UTF-8").index("注文者")
        #   line.force_encoding("UTF-8").match(reg3)
        #   goods ["name"]="#$1"
        # end

        # アイテム名を取得
        if line.force_encoding("UTF-8").index("商品名称")
          line.force_encoding("UTF-8").match(reg1)
          good_name = "#{$1}(#{$2})"
        end

        # 数量を取得してアイテム名をキーに，数量をバリューにしてハッシュに格納
        if line.force_encoding("UTF-8").index("数量")
          line.force_encoding("UTF-8").match(reg2)
          @parsed_items[good_name] = "#{$1}"
        end
      end
      # ファイルクローズ
      file.close

      # デバッグ出力
      # @parsed_items.each do|key,value|
      #   puts key.to_s+": "+value.to_s
      # end

      # パースしたデータをもとにアイテムエントリを作成
      @parsed_items.each do|key,value|
        #puts key.to_s+": "+value.to_s

        # 名前で重複を許さない場合
        # flag = Item.where(name: foodname).exists?
        # if flag == false

        # アイテム名で賞味期限データベースを検索して，
        # 賞味期限データが存在すればこれをもとに期限日を算出する
        start_date = Date.today.to_s
        end_date = Date.today.to_s
        freshness = Freshness.where(:name => key)
        if freshness
          tmp = Date.today + freshness
          end_date = tmp.to_s
        end

        # 新規アイテムを作成
        @touroku = Item.create(title: key,
                               user_id: current_user.id,
                               amount_at_a_time: value,
                               gram_at_a_time: 0,
                               price_at_a_time: 0,
                               price_at_one_amount: 0,
                               price_at_one_gram: 0,
                               start: start_date,
                               end: end_date,
                               allDay: true,
                               remaining_amount: value,
                               description: 説明を入力して下さい,
                               icon: false)
        if @touroku.save
          render text: "新規にデータを登録しました:#{new_name}"
        else
          render text: "新規データ登録に失敗しました:#{new_name}"
        end

        # else
        #   render text: "既にデータが存在しています: #{new_name}"
        # end
      end
    # メールファイルが見つからなかった場合
    rescue
      puts"the mail file is inexistence"
      #retry
    end
  end


  #=================================================================================================================================================
  # レシピ提案
  # acquire_recommended_recipes(queries) は検索したいアイテムを配列で渡してやることで
  # cookpadをOR検索してスクレイピングし，この結果をまとめて，レシピ構造体を要素に持つ配列として返す．
  # 一時的にテキストファイルに保存する機能も提供．

  # 構造体でデータ管理のためのクラス(モデル．だがrailsのモデルではない)を作成．
  # 定数として宣言するため，メソッドの内部では定義せずに外で定義すること

  # レシピ管理クラス
  # レシピ1つ分を表現する．
  # 複数のレシピがrecipe_listに格納される．
  # ingredientsにはIngredientインスタンスが要素の配列ingredient_listが入る
  Recipe = Struct.new(:id, :title, :amount, :ingredient_list, :url, :date)

  # レシピ食材管理クラス
  Ingredient = Struct.new(:id, :name, :amount)

  def acquire_recommended_recipes(queries)
    ##############################
    # Randomクラスの定義
    ##############################
    random = Random.new

    ###################################
    # 変数
    ###################################
    id_num = 1	# id設定用変数
    recipe_list = Array.new		# レシピ用配列
    #ingredient_list = Array.new	# 食材用配列

    ##############################
    # 読み込むURIの階層数の設定
    # 0 => 指定したURIのみ読み込む
    # 1(or more) => 指定したURIにあるlinkから1(or more)回のジャンプで辿れるURIも読み込む
    ##############################
    opts = { depth_limit: 1 }

    ##############################
    # 検索クエリを取得して1本の文字列にする
    # 配列で渡ってきたクエリを使う．
    # クエリが指定されて折らず空配列だった場合は「りんご+バナナ」で検索
    ##############################
    query = ""
    if (queries.length == 0)
      query = "りんご%20バナナ"			# デフォルト値
    else
      queries.each do |arg|
        query = query + "%20"		# クックパッド内蔵検索機能用
        #query = query + "+"		# Google検索機能用
        query = query + arg
      end
    end

    ###################################
    # りんごとバナナのOR検索URI例
    # http://cookpad.com/search/バナナ%20りんご
    ###################################
    uri = Addressable::URI.parse("http://cookpad.com/search/#{query}").normalize
    uri.query_values = {order: 'date', page: '1'}

    ##############################
    # Anemoneでクローラの起動
    # 引数1 => クロールしたいURI
    # 引数2 => 階層数の設定
    ##############################
    Anemone.crawl(uri.to_s, opts) do |anemone|
      ##############################
      # 料理詳細ページに対するスクレイピングの実行
      ##############################
      anemone.on_pages_like(%r{http://cookpad.com/recipe/[0-9]+}) do |page|
        ##############################
        # page.docでnokogiriインスタンスを取得し、
        # xpathで欲しい要素(ノード)を絞り込む
        ##############################
        page.doc.xpath("//div[@id='main']").each do |node|
          ##############################
          # レシピタイトルの抽出
          ##############################
          title = node.xpath(".//div[@id='recipe']/div[@id='recipe-main']/div[@id='recipe-title']/h1[contains(@class,'recipe-title')]//text()").to_s
          title = title.strip													# 文字列の前後に含まれる空白の削除
          title = title.gsub( Regexp.new("&amp;", Regexp::IGNORECASE) , "&")			# 「$amp;」を「&」に変換

          ##############################
          # 分量(何人分の材料)の抽出
          ##############################
          amount = node.xpath(".//div[@id='recipe']/div[@id='recipe-main']//h3[@class='servings_title']/div[@class='content']/span[@class='servings_for yield']//text()").to_s
          amount = amount.strip													# 文字列の前後に含まれる空白の削除
          amount = amount.gsub( Regexp.new("[\(\)（）]", Regexp::IGNORECASE) , "")		# 分量の前後に()が含まれているので削除する
          amount = amount.tr("０-９ａ-ｚＡ-Ｚ", "0-9a-zA-Z")							# 全角英数字を半角英数字に変換
          amount = amount.gsub( Regexp.new("．", Regexp::IGNORECASE) , ".")			# 特殊文字の変換

          ##############################
          # レシピURLと取得日の表示
          ##############################
          url = page.url.to_s
          date = `date`

          ##############################
          # 原材料の抽出
          ##############################
          ingredient_list = Array.new	# 食材用配列
          node.xpath(".//div[@id='recipe']/div[@id='recipe-main']//div[@id='ingredients_list']/div[contains(@class,'ingredient_row')]").each do |ingredients|
            ingredient = ingredients.xpath("./div[@class='ingredient_name']/span[@class='name']//text()").to_s			# 原材料名
            ingredient_amount = ingredients.xpath("./div[@class='ingredient_quantity amount']//text()").to_s			# 原材料の必要個数

            # 原材料の表示
            if(ingredient != "")
              for name in ingredient.split(%r{[,・/、]}) do			# 1行に複数の食材を含むものを分離
                name = name.strip																				# 文字列の前後に含まれる空白の削除
                name = name.gsub( Regexp.new("(☆|★|●|○|■|◎|・|◆|＊|▪️)", Regexp::IGNORECASE) , "")					# 原材料名の先頭に記述された記号の削除
                name = name.tr("０-９ａ-ｚＡ-Ｚ", "0-9a-zA-Z")														# 全角英数字を半角英数字に変換
                name = name.gsub( Regexp.new("．", Regexp::IGNORECASE) , ".")										# 特殊文字の変換

                ingredient_amount = ingredient_amount.strip													# 文字列の前後に含まれる空白の削除
                ingredient_amount = ingredient_amount.tr("０-９ａ-ｚＡ-Ｚ", "0-9a-zA-Z")								# 全角英数字を半角英数字に変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("㌘", Regexp::IGNORECASE) , "g")			# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("㍉", Regexp::IGNORECASE) , "m")			# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("½", Regexp::IGNORECASE) , "1/2")			# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("¼", Regexp::IGNORECASE) , "1/4")			# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("¾", Regexp::IGNORECASE) , "3/4")			# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("．", Regexp::IGNORECASE) , ".")				# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("／", Regexp::IGNORECASE) , "/")				# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("匙", Regexp::IGNORECASE) , "さじ")			# 特殊文字の変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("([0-9])半", Regexp::IGNORECASE) , "\\1.5")		# 大さじ2半 → 大さじ2.5 に変換
                ingredient_amount = ingredient_amount.gsub( Regexp.new("各", Regexp::IGNORECASE) , "")				# 各の削除

                # 食材リストの更新
                ingredient_list << Ingredient.new(id_num, name, ingredient_amount)
              end
            end
          end

          ##############################
          # レシピリストの更新
          ##############################
          if (title != "")
            recipe_list << Recipe.new(id_num, title, amount, ingredient_list, url, date)
          else		# レシピが削除されている場合やページが存在しない場合のための処理
            not_found = node.xpath("./div[@id='not_found']/div[@id='not_found_message']//text()").to_s
            not_found = not_found.strip
            # レシピが削除されているまたはレシピが登録されていないページの場合の処理
            if (not_found != "")
              puts "\n<<<#{not_found}>>>\n\n"
              # ページが存在しない場合の処理
            else
              puts "\n<<<not found>>>\n\n"
            end
            break
          end
        end

        ##############################
        # レシピIDの更新
        ##############################
        puts "recipeID:" + id_num.to_s + " is finished."
        id_num += 1

        ##############################
        # 0.1~1.0秒の間でランダム時間待つ
        ##############################
        sleep(random.rand(1..10)*0.01)
      end
    end

    # ##############################
    # # txtファイルへ書込み
    # ##############################
    # File.open("./tmp/recipe.txt", "w") do |file|
    #   for recipe in recipe_list do
    #     file.puts "\n--------------------------------------------------\n"
    #     if (recipe.amount != "")
    #       file.puts "------ " + recipe.title + " (" + recipe.amount + ") ------\n"
    #     else
    #       file.puts "------ " + recipe.title + " ------\n"
    #     end
    #     file.puts "--------------------------------------------------\n\n"
    #     for ingredient in recipe.ingredient_list do
    #       # if (recipe.id == ingredient.id)
    #       file.puts "\t" + ingredient.name + " => " + ingredient.amount
    #       # end
    #     end
    #     file.puts "\n\t" + "URL: " + recipe.url + "\n\t" + "取得日: " + recipe.date + "\n"
    #     file.puts "--------------------------------------------------\n"
    #   end
    # end

    # レシピ構造体が要素である配列を返す
    return recipe_list
  end


  #=================================================================================================================================================
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :amount_at_a_time, :gram_at_a_time, :price_at_a_time, :price_at_one_amount, :price_at_one_gram, :description, :icon,
                                   :user_id, :start, :end, :remaining_amount, :remaining_gram, :allDay)
    end


    def image_params
      params.require(:image).permit(
          :filename,:file
      )
    end
end
