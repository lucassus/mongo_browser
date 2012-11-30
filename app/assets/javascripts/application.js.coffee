#= require app/services
#= require app/directives
#= require app/filters
#= require_tree ./app/controllers

# App Module
angular.module("mb", ["mb.services", "mb.directives", "mb.filters"])
