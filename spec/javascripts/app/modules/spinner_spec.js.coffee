describe "mb.spinner", ->
  beforeEach module("mb.spinner")

  pendingRequests = null
  beforeEach inject ($injector) ->
    pendingRequests = $injector.get("pendingRequests")

  describe "pendingRequests", ->
    it "has @counter", ->
      expect(pendingRequests.counter).toBeDefined()
      expect(pendingRequests.counter).toEqual(0)

    describe "#increment", ->
      it "increments the @counter", ->
        pendingRequests.increment()
        expect(pendingRequests.counter).toEqual(1)

        pendingRequests.increment()
        expect(pendingRequests.counter).toEqual(2)

    describe "#decrement", ->
      describe "when the @counter is 0", ->
        beforeEach -> pendingRequests.counter = 0

        it "does nothing", ->
          pendingRequests.decrement()
          expect(pendingRequests.counter).toEqual(0)

      describe "when the @counter is > 0", ->
        beforeEach -> pendingRequests.counter = 2

        it "decrements the @counter", ->
          pendingRequests.decrement()
          expect(pendingRequests.counter).toEqual(1)

          pendingRequests.decrement()
          expect(pendingRequests.counter).toEqual(0)

    describe "#isPending", ->
      describe "when the number of pending requests is > 0", ->
        beforeEach -> pendingRequests.counter = 2

        it "returns true", ->
          expect(pendingRequests.isPending()).toBeTruthy()

      describe "otherwise", ->
        beforeEach -> pendingRequests.counter = 0

        it "returns false", ->
          expect(pendingRequests.isPending()).toBeFalsy()

  describe "pendingRequestsInterceptor", ->
    interceptor = null
    pendingRequests = null
    promise = null

    beforeEach inject ($injector) ->
      interceptor = $injector.get("pendingRequestsInterceptor")
      pendingRequests = $injector.get("pendingRequests")
      promise = then: jasmine.createSpy("then").andReturn({})

      pendingRequests.counter = 2
      interceptor(promise)

    describe "onSuccess", ->
      it "decrements the counter", ->
        successHandler = promise.then.mostRecentCall.args[0]

        httpResponse = status: 100
        expect(successHandler(httpResponse)).toBe(httpResponse)
        expect(pendingRequests.counter).toEqual(1)

    describe "onError", ->
      it "decrements the counter", ->
        errorHandler = promise.then.mostRecentCall.args[1]

        httpResponse = status: 404
        errorHandler(httpResponse) # TODO test $q.reject(response)
        expect(pendingRequests.counter).toEqual(1)

  describe "controller", ->
    # TODO

  describe "directive", ->
    # TODO
