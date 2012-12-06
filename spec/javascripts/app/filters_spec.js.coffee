describe "filters", ->
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
      o = {
        _id: { $oid: "50bfc4b6dac5d5630800017a" },
        foo: "something",
        comapany_id: { $oid: "50bfc4b6dac5d56308000119" }
      }

      expect(filter(o)).toContain('<span class="key">_id:</span>')
      expect(filter(o)).toContain('ObjectId(<span class="string">"50bfc4b6dac5d5630800017a"</span>)')

      expect(filter(o)).toContain('<span class="key">comapany_id:</span>')
      expect(filter(o)).toContain('ObjectId(<span class="string">"50bfc4b6dac5d56308000119"</span>)')
