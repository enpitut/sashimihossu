
##############################
# gemの読み込み(gemでインストールする必要あり)
##############################
require 'nokogiri'
require 'anemone'
require 'addressable/uri'

##############################
# Randomクラスの定義
##############################
random = Random.new

##############################
# レシピ管理クラス
##############################
Recipe = Struct.new(:id, :title, :amount, :ingredients, :url, :date)

##############################
# レシピ食材管理クラス
##############################
Ingredient = Struct.new(:id, :name, :amount)

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
opts = {
    depth_limit: 1
}

# ##############################
# # 検索クエリを取得して1本の文字列にする
# # railsのコントローラに書く用
# # 配列で渡ってきたクエリを使う．
# # クエリが指定されて折らず空配列だった場合は「りんご+バナナ」で検索
# ##############################
# query = ""
# if (queries.length == 0)
#   query = "りんご%20バナナ"			# デフォルト値
# else
#   queries.each do |arg|
#     query = query + "%20"		# クックパッド内蔵検索機能用
#     #query = query + "+"		# Google検索機能用
#     query = query + arg
#   end
# end
##############################
# 検索クエリの取得して1本の文字列にする
# コマンドライン用
# コマンドライン引数で空白区切りで設定
# コマンドライン引数が指定されていない場合、「りんご+バナナ」で検索
##############################
query = ""
first_arg_flag = true
if (ARGV[0] == nil)
	query = "りんご%20バナナ"			# デフォルト値
else
	ARGV.each do |arg|
		if (first_arg_flag == false)
			query = query + "%20"		# クックパッド内蔵検索機能用
			#query = query + "+"		# Google検索機能用
		else
			first_arg_flag = false
		end
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
    sleep(random.rand(1..10)*0.1)
  end
end

##############################
# txtファイルへ書込み
##############################
File.open("./tmp/recipe.txt", "w") do |file|
  for recipe in recipe_list do
    file.puts "\n--------------------------------------------------\n"
    if (recipe.amount != "")
      file.puts "------ " + recipe.title + " (" + recipe.amount + ") ------\n"
    else
      file.puts "------ " + recipe.title + " ------\n"
    end
    file.puts "--------------------------------------------------\n\n"
    for ingredient in recipe.ingredients do
      # if (recipe.id == ingredient.id)
      file.puts "\t" + ingredient.name + " => " + ingredient.amount
      # end
    end
    file.puts "\n\t" + "URL: " + recipe.url + "\n\t" + "取得日: " + recipe.date + "\n"
    file.puts "--------------------------------------------------\n"
  end
end