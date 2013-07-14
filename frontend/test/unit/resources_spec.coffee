describe "reources", ->
  beforeEach module("mb.resources")

  $httpBackend = null
  beforeEach inject ($injector) ->
    $httpBackend = $injector.get("$httpBackend")

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "Database", ->
    Database = null
    beforeEach inject ($injector) ->
      Database = $injector.get("Database")

    it "is defined", ->
      expect(Database).toBeDefined()

    describe "#query", ->
      it "queries for all databases", ->
        $httpBackend.whenGET("/api/databases").respond([])
        Database.query()
        $httpBackend.flush()

    describe "#$stats", ->
      it "queries for database stats", ->
        $httpBackend.whenGET("/api/databases/test_database/stats").respond({})

        database = new Database(name: "test_database")
        database.$stats()

        $httpBackend.flush()

  describe "Collection", ->
    Collection = null
    beforeEach inject ($injector) ->
      Collection = $injector.get("Collection")
      $httpBackend.whenGET("/api/databases/test_database/collections")
        .respond([])

    it "is defined", ->
      expect(Collection).toBeDefined()

    describe "#query", ->
      it "queries for all collections", ->
        Collection.query(dbName: "test_database")
        $httpBackend.flush()

    describe "#$stats", ->
      it "queries for collection stats", ->
        fakeResponse = foo: "bar"
        $httpBackend.whenGET("/api/databases/test_database/collections/test_collection/stats")
          .respond(fakeResponse)

        collection = new Collection(dbName: "test_database", name: "test_collection")
        collection.$stats (data) ->
          expect(angular.equals(data, fakeResponse)).toBeTruthy()

        $httpBackend.flush()

  describe "Document", ->
    Document = null
    beforeEach inject ($injector) ->
      Document = $injector.get("Document")
      $httpBackend.whenGET("/api/databases/test_database/collections/test_collection/documents")
        .respond([])

    it "is defined", ->
      expect(Document).toBeDefined()

    describe "#query", ->
      it "queries for all documents", ->
        Document.query(dbName: "test_database", collectionName: "test_collection")
        $httpBackend.flush()

    describe "#$query", ->
      it "queries for all documents", ->
        document = new Document(dbName: "test_database", collectionName: "test_collection")
        document.$query()
        $httpBackend.flush()

    describe "$get", ->
      it "gets a document", ->
        $httpBackend.whenGET("/api/databases/test_database/collections/test_collection/documents/document-id").respond([])

        document = new Document(dbName: "test_database", collectionName: "test_collection", id: "document-id")
        document.$get()

        $httpBackend.flush()

    describe "$delete", ->
      it "deletes a document", ->
        $httpBackend.whenDELETE("/api/databases/test_database/collections/test_collection/documents/document-id").respond([])

        document = new Document(dbName: "test_database", collectionName: "test_collection", id: "document-id")
        document.$delete()

        $httpBackend.flush()
