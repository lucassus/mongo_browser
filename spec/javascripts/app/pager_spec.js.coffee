describe "pager module", ->
  beforeEach module("mb.pager")

  describe "pager service", ->
    it "is defined", inject (pager) ->
      expect(pager).toBeDefined()

    it "can be instantiated", inject (pager) ->
      p = pager(totalPages: 99, outerWindow: 0)

      expect(p.page).toEqual(1)
      expect(p.totalPages).toEqual(99)
      expect(p.innerWindow).toEqual(4)
      expect(p.outerWindow).toEqual(0)

    describe "windowedPageNumbers", ->

      it "calculates windowed visible links", inject (pager) ->
        prepare = pager(page: 6, totalPages: 11, innerWindow: 1, outerWindow: 1)
        expect(prepare.windowedPageNumbers()).toEqual [1, 2, null, 5, 6, 7, null, 10, 11]

      it "eliminates small gaps", inject (pager) ->
        prepare = pager(page: 6, totalPages: 11, innerWindow: 2, outerWindow: 1)
        # pages 4 and 8 appear instead of the gap
        expect(prepare.windowedPageNumbers()).toEqual [1..11]

      it "supports having no windows at all", inject (pager) ->
        prepare = pager(page: 4, totalPages: 7, innerWindow: 0, outerWindow: 0)
        expect(prepare.windowedPageNumbers()).toEqual [1, null, 4, null, 7]

      it "adjusts upper limit if lower is out of bounds", inject (pager) ->
        prepare = pager(page: 1, totalPages: 10, innerWindow: 2, outerWindow: 1)
        expect(prepare.windowedPageNumbers()).toEqual [1, 2, 3, 4, 5, null, 9, 10]

      it "adjusts lower limit if upper is out of bounds", inject (pager) ->
        prepare = pager(page: 10, totalPages: 10, innerWindow: 2, outerWindow: 1)
        expect(prepare.windowedPageNumbers()).toEqual [1, 2, null, 6, 7, 8, 9, 10]

  describe "pager controller", ->
    $scope = null

    beforeEach inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()
      $controller("pager", $scope: $scope)

      $scope.page = 2
      $scope.totalPages = 10

    describe "#setPage", ->
      it "sets the current page", ->
        $scope.setPage(3)
        expect($scope.page).toBe(3)

      describe "when the new page number is < 1", ->
        it "sets to the first page", ->
          for newPage in [1, 0, -1]
            $scope.setPage(newPage)
            expect($scope.page).toBe(1)

      describe "when the new page is > totalPages", ->
        it "sets to the last page", ->
          for newPage in [10, 11, 12]
            $scope.setPage(newPage)
            expect($scope.page).toBe(10)

    describe "#next", ->
      it "sets to the next page", ->
        $scope.page = 9
        $scope.next()
        expect($scope.page).toBe(10)

      describe "when the current page is the last page", ->
        it "sets does nothig", ->
          $scope.page = 9
          $scope.next()
          expect($scope.page).toBe(10)

    describe "#hasNext", ->
      it "return true when there is a next page", ->
        $scope.page = 9
        expect($scope.hasNext()).toBeTruthy()

        $scope.page = 10
        expect($scope.hasNext()).toBeFalsy()

    describe "#prev", ->
      it "sets to the prev page", ->
        $scope.page = 9
        $scope.prev()
        expect($scope.page).toBe(8)

      describe "when the current page is the last first", ->
        it "sets does nothig", ->
          $scope.page = 1
          $scope.prev()
          expect($scope.page).toBe(1)

    describe "#hasPrev", ->
      it "return true when there is a previous page", ->
        $scope.page = 9
        expect($scope.hasPrev()).toBeTruthy()

        $scope.page = 1
        expect($scope.hasPrev()).toBeFalsy()
