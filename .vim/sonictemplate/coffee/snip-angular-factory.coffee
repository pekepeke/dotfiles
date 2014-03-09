myApp = angular.module 'myApp', ['$http']

myApp.factory 'SomeBackendService', ($rootScope, $http) ->
  items = null
  return {
    get : () -> items
    reset : () -> items = undefined
    set: (newItem) -> items = newItem
  }
