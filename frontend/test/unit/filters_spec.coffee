describe "filters", ->
  beforeEach module("mb.templates")
  beforeEach module("mb.filters")

  describe "humanSize", ->
    filter = null

    beforeEach inject (humanSizeFilter) ->
      filter = humanSizeFilter

    it "formats bytes", ->
      expect(filter(1)).toEqual("1 Bytes")
      expect(filter(1000)).toEqual("1000 Bytes")
      expect(filter(1023)).toEqual("1023 Bytes")

    it "formats kilobytes", ->
      expect(filter(1024)).toEqual("1 KB")

    it "formats megabytes", ->
      megabyte = 1024 * 1024

      expect(filter(megabyte)).toEqual("1 MB")
      expect(filter(250 * megabyte)).toEqual("250 MB")

    it "formats gigabytes", ->
      gigabyte = 1024 * 1024 * 1024

      expect(filter(gigabyte)).toEqual("1 GB")
      expect(filter(2.6 * gigabyte)).toEqual("3 GB")

  describe "jsonDocument", ->
    filter = null

    beforeEach inject (jsonDocumentFilter) ->
      filter = jsonDocumentFilter

    it "can highlight strings", ->
      o = { foo: "bar" }

      expect(filter(o)).toContain('<span class="key">foo:</span>')
      expect(filter(o)).toContain('<span class="string">"bar"</span>')

    it "can highlight numbers", ->
      o = { bar: 123.99 }

      expect(filter(o)).toContain('<span class="key">bar:</span>')
      expect(filter(o)).toContain('<span class="number">123.99</span>')

    it "can highlight booleans", ->
      o = { foo: false }

      expect(filter(o)).toContain('<span class="key">foo:</span>')
      expect(filter(o)).toContain('<span class="boolean">false</span>')

    it "can highlight nulls", ->
      o = { foo: null }

      expect(filter(o)).toContain('<span class="key">foo:</span>')
      expect(filter(o)).toContain('<span class="null">null</span>')

    it "can format ObjectId", ->
      document = {
        _id: { $oid: "50bfc4b6dac5d5630800017a" },
        foo: "something",
        comapany_id: { $oid: "50bfc4b6dac5d56308000119" }
      }

      expect(filter(document)).toContain('<span class="key">_id:</span>')
      expect(filter(document)).toContain('ObjectId(<span class="string">"50bfc4b6dac5d5630800017a"</span>)')

      expect(filter(document)).toContain('<span class="key">comapany_id:</span>')
      expect(filter(document)).toContain('ObjectId(<span class="string">"50bfc4b6dac5d56308000119"</span>)')

  # url helpers

  describe "#collectionsPath", ->
    filter = null

    beforeEach inject (collectionsPathFilter) ->
      filter = collectionsPathFilter

    it "without parameters generates an url with placeholders", ->
      expect(filter()).toEqual("/databases/:dbName/collections")

    it "generates an url for the given database collections", ->
      database = { name: "foo_bar" }
      expect(filter(database)).toEqual("/databases/foo_bar/collections")

  describe "#documentsPath", ->
    filter = null

    beforeEach inject (documentsPathFilter) ->
      filter = documentsPathFilter

    it "without parameters generates an url with placeholders", ->
      expect(filter()).toEqual("/databases/:dbName/collections/:collectionName/documents")

    it "generates na url for the given collection documents", ->
      collection = { dbName: "foo", name: "bars" }
      expect(filter(collection)).toEqual("/databases/foo/collections/bars/documents")

  describe "#documentPath", ->
    filter = null

    beforeEach inject (documentPathFilter) ->
      filter = documentPathFilter

    it "without parameters generates an url with placeholders", ->
      expect(filter()).toEqual("/databases/:dbName/collections/:collectionName/documents/:id")

    it "generates na url for the given collection documents", ->
      document = { dbName: "foo", collectionName: "bars", id: "documentId" }
      expect(filter(document)).toEqual("/databases/foo/collections/bars/documents/documentId")

  describe "documentPrettyTime", ->
    filter = null

    beforeEach inject (documentPrettyTimeFilter) ->
      filter = documentPrettyTimeFilter

    it "extracts time from document id", ->
      expect(filter(id: "50c33814dac5d5c9310001bd"))
        .toEqual("Sat, 08 Dec 2012 12:52:36 GMT")

      expect(filter(id: "50d7134ddac5d501aa000003"))
        .toEqual("Sun, 23 Dec 2012 14:21:01 GMT")
