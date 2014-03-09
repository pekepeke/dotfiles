myappServices = angular.module('myappServices', ['ngResource'])

myappServices.factory 'User', [
    '$resource'
    ($resource) ->
      return $resource '/users/:userId.json', {},
        query: {method:'GET', params:{userId:'all'}, isArray:true}
        update: {method: 'PUT'}
  ]

