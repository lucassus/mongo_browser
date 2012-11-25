describe "filters", ->
  beforeEach module("mb.filters")

  describe "humanSize", ->
    it "formats bytes", inject (humanSizeFilter) ->
      expect(humanSizeFilter(1)).toEqual("1 Bytes")
      expect(humanSizeFilter(1000)).toEqual("1000 Bytes")
      expect(humanSizeFilter(1023)).toEqual("1023 Bytes")

    it "formats kilobytes", inject (humanSizeFilter) ->
      expect(humanSizeFilter(1024)).toEqual("1 KB")

    it "formats megabytes", inject (humanSizeFilter) ->
      megabyte = 1024 * 1024

      expect(humanSizeFilter(megabyte)).toEqual("1 MB")
      expect(humanSizeFilter(250 * megabyte)).toEqual("250 MB")

    it "formats gigabytes", inject (humanSizeFilter) ->
      gigabyte = 1024 * 1024 * 1024

      expect(humanSizeFilter(gigabyte)).toEqual("1 GB")
      expect(humanSizeFilter(2.6 * gigabyte)).toEqual("3 GB")
