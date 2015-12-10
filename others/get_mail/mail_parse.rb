begin
  reg1=/.?商品名称.?[\s]*(.+)[\s]([0-9]+.*)/
  reg2=/.*数量.?([0-9]+).*/
  reg3=/.*注文者.?[\s]*(.+)[\s]+様/
  df="mail.txt"
  file=File.new(df)
  #if file
  # 全データを入れるハッシュを作成
  goods = Hash.new
  # ファイルをパース
  while line=file.gets
    # 注文者を取得
#     if line.force_encoding("UTF-8").index("注文者")
#       line.force_encoding("UTF-8").match(reg3)
#       goods ["name"]="#$1"
#     end
    # アイテム名を取得
    if line.force_encoding("UTF-8").index("商品名称")
      #i =/コカ・コーラ 爽健美茶/ =~ line.force_encoding("UTF-8")[ぁ-んァ-ヴ一-龠亜-煕]
      line.force_encoding("UTF-8").match(reg1)
      good_name = "#{$1}(#{$2})"
    end
    # 数量を取得してアイテム名をキーに，数量をバリューにしてハッシュに格納
    if line.force_encoding("UTF-8").index("数量")
      line.force_encoding("UTF-8").match(reg2)
      goods[good_name] = "#{$1}"
    end
  end
  file.close
  
  # デバッグ出力
  goods.each do|key,value|
    puts key.to_s+": "+value.to_s
  end
rescue
  puts"the mail file is inexistence"
  #retry
end