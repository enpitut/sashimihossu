$(document).ready(function() {
    var calendar = $('#calendar').fullCalendar({
        // hoge
        //ヘッダーの設定
        header: {
            //それぞれの位置に設置するボタンやタイトルをスペース区切りで指定できます。指定しない場合、非表示にできます。
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

        slotEventOverlap: false, //スケジュールが重なったとき、重ねて表示するかどうか（falseにすると、重ねずに表示する）
        axisFormat: 'H:mm', //時間軸に表示する時間の表示フォーマットを指定する(表示方法はtimeFormatと同じ)
        slotDuration: '01:00:00', //表示する時間軸の細かさ
        snapDuration: '01:00:00', //スケジュールをスナップするときの動かせる細かさ
        minTime: "00:00:00", //スケジュールの開始時間
        maxTime: "24:00:00", //スケジュールの最終時間
        defaultTimedEventDuration: '01:00:00', //画面上に表示する初めの時間(スクロールされている場所)


        // ドラッグ範囲選択後処理。開始日、終了日が渡ってくる
        select: function(start, end) {
            var title = prompt('イベントタイトル:');
            var eventData;
            if (title) {
                eventData = {
                    title: title,
                    start: start,
                    end: end
                };
                calendar.fullCalendar('renderEvent', eventData, true); // stick? = true
            }
            calendar.fullCalendar('unselect');
        },

        //イベントをクリックしたときに実行
        eventClick: function(event, jsEvent, view) {
            //alert('イベント名: ' + event.title + '\n座標: ' + jsEvent.pageX + ',' + jsEvent.pageY + '\nスケジュール: ' + view.name);
            // change the border color just for fun
            //$(this).css('border-color', 'red');

            var title = prompt('予定を入力してください:', event.title);
            if(title && title!=""){
                event.title = title;
                calendar.fullCalendar('updateEvent', event); //イベント（予定）の修正
            }else{
                calendar.fullCalendar("removeEvents", event.id); //イベント（予定）の削除
            }
        },

        // イベントではないところをクリックしたとき(日をクリックしたとき)に実行
        dayClick: function(date, jsEvent, view){
            //alert('クリックした時間: ' + date.format() + '\n座標: ' + jsEvent.pageX + ',' + jsEvent.pageY+'\nスケジュール: ' + view.name);
            // change the day's background color just for fun
            //$(this).css('background-color', 'red');
        },

        // 外部要素からドラッグアンドドロップしたときに実行
        drop: function(date){

        },

        //カレンダー上にドラッグし終わったときに実行
        eventDragStop: {

        },


        ////////////////////////////////
        // イベントを保持するモデルと連携 //
        ////////////////////////////////

        // 普通はこのようにする
        //events: '/user_items.json',
        // 現在のユーザを特定してそのユーザに紐付いた商品をとってくるための専用のルーティングで専用のメソッドに飛ばす (user_itemsコントローラのitems_by_userメソッド)
        events: '/user_items/user/current_user',


        ////////////////////////
        // googleカレンダー連携 //
        ////////////////////////
        // 現状、画面遷移をせずに行えるのはgoogleカレンダーからの情報取得のみである。
        // こちらのカレンダー画面上で行った変更をgoogleカレンダーに反映するには、googleカレンダーのapiを叩く必要がありそう。
        // なお、イベントをクリックしてgoogleカレンダーの編集画面にページ遷移して編集を行うことはそのままでも可能。

        // googleカレンダーのapiキーを取得してきてここで指定
        googleCalendarApiKey: 'AIzaSyAZ0D6051j4yjFiNq1prTyc99O9bXE8GNU',
        // カレンダーが1つだけ良い場合は以下
        //events:{
        //    googleCalendarId: 'primary'
        //},
        // 複数のカレンダーを登録したい場合は以下
        eventSources: [
            {
                googleCalendarId: 'a4e7941fuie2e6n7i1u65fihn8@group.calendar.google.com',
                className: 'fridge1'
            }//,
            //{
            //    url: "",
            //    className: "event2"
            //}
        ]
    });

    //カレンダーを再描画
    //$('#calendar').fullCalendar('rendar');

    //カレンダーを削除
    //$('#calendar').fullCalendar('destroy');

    //イベントを追加
    //$('#calendar').fullCalendar('renderEvent', event, true); //eventはeventオブジェクト

    //イベントを更新
    //$('#calendar').fullCalendar('updateEvent', event);
});