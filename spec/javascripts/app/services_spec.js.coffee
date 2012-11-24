describe "services", ->
  beforeEach module("mb.services")

  describe "tableFilter", ->
    scope = null
    tableFilter = null

    beforeEach inject ($injector) ->
      factory = $injector.get('tableFilterFactory')

      scope =
        dummyCollection: [
            name: "first_item"
          ,
            name: "second_item"
          ,
            name: "third"
        ]

      tableFilter = factory(scope, "dummyCollection")

    describe "#filter", ->
      it "filters the given collection", ->
        expect(tableFilter).toBeDefined()

        tableFilter.filter("first")
        expect(scope.dummyCollection.length).toEqual(1)
        expect(tableFilter.collectionCopy.length).toEqual(3)
        expect(scope.dummyCollection).toContain(name: "first_item")

        tableFilter.filter("item")
        expect(scope.dummyCollection.length).toEqual(2)
        expect(tableFilter.collectionCopy.length).toEqual(3)
        expect(scope.dummyCollection).toContain(name: "first_item")
        expect(scope.dummyCollection).toContain(name: "second_item")

        tableFilter.filter("fourth")
        expect(scope.dummyCollection.length).toEqual(0)
        expect(tableFilter.collectionCopy.length).toEqual(3)

    describe "#matchesCount", ->
      it "returns a number of matches elements", ->
        tableFilter.filter("")
        expect(tableFilter.matchesCount()).toEqual(3)

        tableFilter.filter("item")
        expect(tableFilter.matchesCount()).toEqual(2)

        tableFilter.filter("third")
        expect(tableFilter.matchesCount()).toEqual(1)

        tableFilter.filter("fourth")
        expect(tableFilter.matchesCount()).toEqual(0)

    describe "#noMatches", ->
      it "returs true if filtered collection is empty", ->
        tableFilter.filter("fourth")
        expect(tableFilter.noMatches()).toBeTruthy()

      it "return false if filtered collection is not empty", ->
        tableFilter.filter("item")
        expect(tableFilter.noMatches()).toBeFalsy()
