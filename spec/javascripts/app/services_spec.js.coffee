describe "services", ->
  beforeEach module("mb.alerts")
  beforeEach module("mb.services")
  beforeEach module("mocks")

  describe "httpErrorsInterceptor", ->
    $http = null
    promise = null

    interceptor = null
    alerts = null
    $q = null

    beforeEach inject ($injector) ->
      $http = $injector.get("$http")
      interceptor = $injector.get("httpErrorsInterceptor")
      alerts = $injector.get("alerts")
      $q = $injector.get("$q")

      promise = then: jasmine.createSpy("then").andReturn({})
      interceptor(promise)

    it "alerts an error on failed http request", ->
      spyOn(alerts, "push")
      spyOn($q, "reject")

      errorHandler = promise.then.mostRecentCall.args[1]
      httpResponse = status: 500
      errorHandler(httpResponse)

      expect(alerts.push).toHaveBeenCalledWith("error", "HTTP error")
      expect($q.reject).toHaveBeenCalledWith(httpResponse)
