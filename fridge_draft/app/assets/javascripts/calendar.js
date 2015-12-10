$(document).ready(function() {
    // jqueryにおいてカレンダーを実装するfullcalendarを実行する設定を単独ファイルにしたもの．
    // fullcalendarは，適当な特定のカラムを持つrailsのモデルに登録されたエントリをイベントとみなし，それを表示したりすることができる．
    var calendar = $('#calendar').fullCalendar({

        //=========
        // 各種設定
        //=========

        //ヘッダーの設定
        header: {
            // カレンダーの上の左・中央・右に設置するボタンやタイトルをスペース区切りで指定。指定しない場合は非表示
            // 'title'→月・週・日のそれぞれの表示に応じたタイトル
            // 'prev'→前へボタン
            // 'next'→次へボタン
            // 'today'→当日表示ボタン
            left: 'today', //'month agendaWeek agendaDay', //左側に配置する要素
            center: 'title', //中央に配置する要素
            right: 'prev next' //右側に配置する要素
        },

        height: window.innerHeight - 142, //高さをピクセルで指定
        defaultView: 'month', // 初めの表示内容を指定 http://fullcalendar.io/docs/views/Available_Views/
        editable: true, // trueでスケジュールを編集可能にする
        selectable:true, // ドラッグで範囲選択
        selectHelper:true,
        droppable: false, // 外部要素からのドラッグアンドドロップ
        draggable: false,
        allDaySlot: false, //falseでagendaDay表示のときに全日の予定欄の表示非表示

        //時間の表示フォーマットを指定する http://momentjs.com/docs/#/displaying/format/
        timeFormat: {
            agenda: 'H(:mm)'
        },

        ignoreTimezone: false,

        slotEventOverlap: false, //スケジュールが重なったとき、重ねて表示するかどうか（falseにすると、重ねずに表示する）
        axisFormat: 'H:mm', //時間軸に表示する時間の表示フォーマットを指定する(表示方法はtimeFormatと同じ)
        slotDuration: '01:00:00', //表示する時間軸の細かさ
        snapDuration: '01:00:00', //スケジュールをスナップするときの動かせる細かさ
        minTime: "00:00:00", //スケジュールの開始時間
        maxTime: "24:00:00", //スケジュールの最終時間
        defaultTimedEventDuration: '01:00:00', //画面上に表示する初めの時間(スクロールされている場所)




        //===============================================================
        // イベントを保持するモデル(今回はuser_item)との連携で表示用データを取得
        //===============================================================

        // fullcalendarの仕組みとしては，title, start, endというカラムを持ったモデルから抽出したエントリをjsonで渡してやれば，
        // これをイベントとして処理し，カレンダーに表示してくれるというもの．

        // なので，普通はこのようにしてコントローラ経由でモデルから引っ張ってきたjsonデータを渡してやる．
        //events: '/user_items.json',

        // 今回は，全てのエントリではなく，現在のユーザを特定してそのユーザに紐付いたエントリ(商品)をとってくる必要がある．
        // なので，そのための専用のルーティングで専用のメソッドに飛ばす． (user_itemsコントローラのitems_by_userメソッド)
        // これはjsonデータを返してくるようにコントローラで記述しているので，下記のように書けばカレンダーにイベントが表示される．
        events: '/items/index_by_user.json',




        //====================
        // googleカレンダー連携
        //====================

        // googleカレンダー連携は，「バックアップ」「googleカレンダーで見れたら便利」程度の意味のフィーチャーであり，必須ではない．
        // イベントデータの管理自体は，user_itemモデルだけでもできる．
        // なので今回は使用しないでいいかも？

        // 現状、画面遷移をせずに行えるのはgoogleカレンダーからの情報取得のみである。
        // こちらのカレンダー画面上で行った変更をgoogleカレンダーに反映するには、googleカレンダーのapiを叩く必要があると思われる。
        // なお、イベントをクリックしてgoogleカレンダーの編集画面にページ遷移して編集を行うことはそのままでも可能。

        //// googleカレンダーのapiキーを取得してきてここで指定
        //googleCalendarApiKey: 'AIzaSyAZ0D6051j4yjFiNq1prTyc99O9bXE8GNU',
        //// カレンダーが1つだけ良い場合は以下
        ////events:{
        ////    googleCalendarId: 'primary'
        ////},
        //// 複数のカレンダーを登録したい場合は以下
        //eventSources: [
        //    {
        //        googleCalendarId: 'a4e7941fuie2e6n7i1u65fihn8@group.calendar.google.com',
        //        className: 'fridge1'
        //    }//,
        //    //{
        //    //    url: "",
        //    //    className: "event2"
        //    //}
        //],




        //================
        // イベントハンドラ
        //================

        // カレンダーのマスを単体選択・ドラッグ範囲選択したときの処理。開始日、終了日が渡ってくる
        select: function(start, end) {
            // railsのモデルと連携せずにフロントだけに反映させるならこれでよい
            //var title = prompt('イベントを登録します．イベントタイトル:');
            //var eventData;
            //if (title) {
            //    eventData = {
            //        title: title,
            //        start: start,
            //        end: end
            //    };
            //    calendar.fullCalendar('renderEvent', eventData, true); // stick? = true
            //}
            //calendar.fullCalendar('unselect');

            //---------------------------------
            // データを作成してサーバ側へ反映させる
            //---------------------------------

            // 以下は全てdefferedのthenでつなげるように書き換える

            var title = window.prompt("食材を登録します．食材名:");
            //何も入力されなければイベントを作らない
            if (title == null) {
                console.log("event create was aborted.");
                return;
            }

            // ここで，上記で入力された食材名からデータベースにアクセスして賞味期限をとってくる
            var freshness = -1;
            var data = {name: title};
            $.ajax({
                type: "GET",
                url: "freshnesses/freshness_by_name.json",
                dataType: "json",
                data: data
            }).done(function(response){
                //
            }).fail(function(response){
                //alert("error!");
            //以前のcompleteに相当．ajaxの通信に成功した場合はdone()と同じ，失敗した場合はfail()と同じ引数を返す．
            }).always(function(response){
                //console.log(response);
                // 賞味期限を取得(該当する食材がデータベースに無かった場合は0が返ってくる)
                freshness = response;
                // 賞味期限が見つかった場合はそれをもとに賞味期限日付を設定．
                // 見つからなかった場合はカレンダーで範囲選択された際のそのままの終了日を設定
                var end2 = end;
                if (freshness != 0) {
                    end2 = end2.add('days', freshness);
                }

                // 現在のユーザidをサーバ側からとってくる
                var current_user_id = -1;
                $.ajax({
                    type: "GET",
                    url: "items/current_user_id",
                }).done(function(response){ //ajaxの通信に成功した場合
                    //console.log(response);
                    current_user_id = response;

                    // 新規アイテムを作成
                    var data2 = {item: {
                        //user_id: hoge,
                        //item_id: hoge,
                        title: title,
                        user_id: current_user_id,
                        start: start.format(), // このようにformat()してやらないとmoment.js周りでエラーを吐いてajaxに失敗する
                        end: end2.format(),
                        all_day: true}};
                    //allDay: allDay}};
                    $.ajax({
                        type: "POST",
                        url: "/items",
                        dataType: "json",
                        data: data2
                    }).done(function(response){
                        //console.log(response);
                        calendar.fullCalendar('refetchEvents');
                        var editUrl = "/items/" + response.id + "/edit.js";
                        //window.location.href = editUrl; // 編集画面に遷移
                        // 編集画面をリクエスト(rails側では部分テンプレートとしてこれを返す)
                        $.ajax({
                            type: "GET",
                            url: editUrl
                        }).done(function(response){
                            //
                        }).fail(function(response){
                            alert("error!");
                        });
                    }).fail(function(response){
                        alert("error!");
                    });
                    // カレンダーの選択表示を解除
                    calendar.fullCalendar('unselect');

                }).fail(function(response){ //ajaxの通信に失敗した場合
                    alert("error!");
                });
            });
        },

        // カレンダーのマス内のイベント部分をクリックしたときの処理
        eventClick: function(event, jsEvent, view) {
            // サンプル
            //alert('イベント名: ' + event.title + '\n座標: ' + jsEvent.pageX + ',' + jsEvent.pageY + '\nスケジュール: ' + view.name);
            // change the border color just for fun
            //$(this).css('border-color', 'red');

            // イベントの変更(仮)
            //var title = prompt('予定を入力してください:', event.title);
            //if(title && title!=""){
            //    calendar.fullCalendar("removeEvents", event.id); //イベント（予定）の削除
            //}else{
            //    event.title = title;
            //    calendar.fullCalendar('updateEvent', event); //イベント（予定）の修正
            //}

            // 編集画面に遷移
            //var editUrl = "/items/" + event.id + "/edit";
            //window.location.href = editUrl;

            // アイテムのshowを表示
            $.ajax({
                type: "GET",
                url: "/items/" + event.id + ".js",
            }).done(function(response){ //ajaxの通信に成功した場合
                //$('#right-column').html(response)
            }).fail(function(response){ //ajaxの通信に失敗した場合
                alert("error!");
            });
        },

        // カレンダーのマス内のイベントではない部分をクリックしたときの処理
        dayClick: function(date, jsEvent, view){
            //alert('クリックした時間: ' + date.format() + '\n座標: ' + jsEvent.pageX + ',' + jsEvent.pageY+'\nスケジュール: ' + view.name);
            // change the day's background color just for fun
            //$(this).css('background-color', 'red');
            //alert('hoge');
        },

        // 外部要素からドラッグアンドドロップしたときの処理
        drop: function(date){

        },

        //カレンダー上にドラッグし終わったときの処理
        eventDragStop: {

        }




        //======
        // 参考
        //======

        //カレンダーを再描画
        //$('#calendar').fullCalendar('rendar');

        // カレンダー用のデータを再取得
        //$('#calendar').fullCalendar('refetchEvents');

        //カレンダーを削除
        //$('#calendar').fullCalendar('destroy');

        //イベントを追加
        //$('#calendar').fullCalendar('renderEvent', event, true); //eventはeventオブジェクト

        //イベントを更新
        //$('#calendar').fullCalendar('updateEvent', event);
    });
});