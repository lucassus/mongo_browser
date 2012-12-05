mbDev = angular.module("mbDev", ["mb", "ngMockE2E"]);

mbDev.run ($httpBackend) ->
  databases = [{ name: "phone1" }, { name: "phone2" }]

  $httpBackend.whenGET("/databases.json").respond(databases)
