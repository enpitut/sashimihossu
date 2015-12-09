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
            left: 'month agendaWeek agendaDay', //左側に配置する要素
            center: 'title', //中央に配置する要素
            right: 'today prev next' //右側に配置する要素
        },

        height: 900, //高さをピクセルで指定
        defaultView: 'month', // 初めの表示内容を指定 http://fullcalendar.io/docs/views/Available_Views/
        editable: true, // trueでスケジュールを編集可能にする
        selectable:true, // ドラッグで範囲選択可能
        selectHelper:true,
        droppable: true, // 外部要素からのドラッグアンドドロップを可にする
        allDaySlot: false, //falseでagendaDay表示のときに全日の予定欄を非表示にする

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

            // 以下は全てdefferedのthenでつなげる

            // 新規アイテムを作成
            //var item_id = -1;
            //var title = window.prompt("イベントを登録します．イベントタイトル:");
            //var data = {event: {user_id: hoge,
            //                    item_id: hoge,
            //                    title: title,
            //                    start: start,
            //                    end: end}};
            //                    //allDay: allDay}};
            //$.ajax({
            //    type: "POST",
            //    url: "/user_items",
            //    data: data,
            //    success: function() {
            //        calendar.fullCalendar('refetchEvents');
            //    }
            //});

            // 現在のユーザidをサーバ側からとってくる
            //var current_user_id = -1;
            //$.ajax({
            //    type: "GET",
            //    url: "/user_items/hoge",
            //    data: data
            //}).done(function(data){ //ajaxの通信に成功した場合
            //    //$(".example").html(data);
            //}).fail(function(data){ //ajaxの通信に失敗した場合
            //    //alert("error!");
            //});

            // 以上を用いてイベントを作成・登録
            //var title = window.prompt("イベントを登録します．イベントタイトル:");
            //var data = {event: {user_id: hoge,
            //                    item_id: hoge,
            //                    title: title,
            //                    start: start,
            //                    end: end}};
            //                    //allDay: allDay}};
            //$.ajax({
            //    type: "POST",
            //    url: "/user_items",
            //    data: data
            //}).done(function(data){ //ajaxの通信に成功した場合
            //    calendar.fullCalendar('refetchEvents');
            //}).fail(function(data){ //ajaxの通信に失敗した場合
            //    //alert("error!");
            //});
            //calendar.fullCalendar('unselect');
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