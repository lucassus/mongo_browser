describe "services", ->
  beforeEach module("mb.services")

  describe "version", ->
    it "returns the current version", inject (version) ->
      expect(version).toEqual("0.1")

  describe "tableFilterFactory", ->
    it "filters given collection", inject (tableFilterFactory) ->
      expect(tableFilterFactory).toBeDefined()

      scope =
        collection: ["first_item", "second_item", "third"]

      filter = tableFilterFactory(scope, "collection")
      expect(filter).toBeDefined()

      filter.filter("first")
      expect(scope.collection.length).toEqual(1)

      filter.filter("item")
      expect(scope.collection.length).toEqual(2)
