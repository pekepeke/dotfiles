R.jQuery = R.$ = (el) ->
  if typeof el is "string" and el.charAt(0) isnt '<'
    el = document.querySelectorAll(el)
  angular.element(el)

