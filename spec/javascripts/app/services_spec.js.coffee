describe "services", ->
  beforeEach module("mb.services")

  describe "version", ->
    it "returns the current version", inject (version) ->
      expect(version).toEqual("0.1")

  describe "tableFilterFactory", ->
    it "filters the given collection", inject (tableFilterFactory) ->
      expect(tableFilterFactory).toBeDefined()

      scope =
        collection: [
            name: "first_item"
          ,
            name: "second_item"
          ,
            name: "third"
        ]

      tableFilter = tableFilterFactory(scope, "collection")
      expect(tableFilter).toBeDefined()

      tableFilter.filter("first")
      expect(scope.collection.length).toEqual(1)
      expect(tableFilter.collectionCopy.length).toEqual(3)
      expect(scope.collection).toContain(name: "first_item")
      expect(tableFilter.noMatches()).toBeFalsy()

      tableFilter.filter("item")
      expect(scope.collection.length).toEqual(2)
      expect(tableFilter.collectionCopy.length).toEqual(3)
      expect(scope.collection).toContain(name: "first_item")
      expect(scope.collection).toContain(name: "second_item")
      expect(tableFilter.noMatches()).toBeFalsy()

      tableFilter.filter("fourth")
      expect(scope.collection.length).toEqual(0)
      expect(tableFilter.collectionCopy.length).toEqual(3)
      expect(tableFilter.noMatches()).toBeTruthy()
