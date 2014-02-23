myApp.factory "$exceptionHandler", ->
  (exception, cause) ->
    console.log exception.message
    msg = "エラーが発生しました。"
    alert msg

