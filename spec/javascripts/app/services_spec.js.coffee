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

    errorHandler = null

    beforeEach inject ($injector) ->
      $http = $injector.get("$http")
      interceptor = $injector.get("httpErrorsInterceptor")
      alerts = $injector.get("alerts")
      $q = $injector.get("$q")

      promise = then: jasmine.createSpy("then").andReturn({})
      interceptor(promise)

      spyOn(alerts, "push")
      spyOn($q, "reject")
      errorHandler = promise.then.mostRecentCall.args[1]

    it "alerts an error on failed http request", ->
      httpResponse = status: 500
      errorHandler(httpResponse)

      expect(alerts.push).toHaveBeenCalledWith("error", "Unexpected HTTP error")
      expect($q.reject).toHaveBeenCalledWith(httpResponse)

    describe "when http response includes an error message", ->
      it "alerts this error", ->
        httpResponse = status: 500, data:
          error: "The custom message"
        errorHandler(httpResponse)

        expect(alerts.push).toHaveBeenCalledWith("error", "The custom message")
        expect($q.reject).toHaveBeenCalledWith(httpResponse)
