# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  # ウィンドウリサイズ終了時にカレンダーをリサイズ
#  timer = false
#  $(window).resize ->
#    if timer != false
#      clearTimeout timer
#    timer = setTimeout((->
#      console.log $("#calendar")
#      $(".fc").css("height", window.innerHeight - 120)
#      $('#calendar').fullCalendar({
#        height: $(window).innerHeight - 120
#      });
#      $('#calendar').fullCalendar('rendar')
#      return
#    ), 200)
#    return


  # ウィンドウロード時に右カラムをリサイズ
  $(window).ready ->
    $("#right-column").css("height", window.innerHeight - 142)
    $(".main_content").css("height", $("#right-column").height() - 208)
    return
  # ウィンドウリサイズ終了時に右カラムをリサイズ
  timer = false
  $(window).resize ->
    if timer != false
      clearTimeout timer
    timer = setTimeout((->
      console.log $("#calendar")
      $("#right-column").css("height", window.innerHeight - 142)
      return
    ), 200)
    return