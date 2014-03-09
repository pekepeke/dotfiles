myApp = angular
  .module('myApp', ['$rootScope'])
  .service('SomeUtilService', ($rootScope) ->
    this.utilMethod = () -> 1

