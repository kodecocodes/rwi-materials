/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import PetSave

final class SearchViewModelTestCase: XCTestCase {
  let testContext = PersistenceController.preview.container.viewContext
  var viewModel: SearchViewModel?

  override func setUp() {
    super.setUp()
    viewModel = SearchViewModel(
      animalSearcher: AnimalSearcherMock(),
      animalStore: AnimalStoreService(context: testContext)
    )
  }

  func testShouldFilterIsFalseForEmptyFilters() {
    XCTAssertTrue(((viewModel?.searchText.isEmpty) != nil))
    XCTAssertEqual(viewModel?.ageSelection, AnimalSearchAge.none)
    XCTAssertEqual(viewModel?.typeSelection, AnimalSearchType.none)
    XCTAssertFalse(((viewModel?.shouldFilter) == nil))
  }

  func testShouldFilterIsTrueForSearchText() {
    viewModel?.searchText = "Kiki"
    XCTAssertFalse(((viewModel?.searchText.isEmpty) == nil))
    XCTAssertEqual(viewModel?.ageSelection, AnimalSearchAge.none)
    XCTAssertEqual(viewModel?.typeSelection, AnimalSearchType.none)
    XCTAssertTrue(((viewModel?.shouldFilter) != nil))
  }

  func testShouldFilterIsTrueForAgeFilter() {
    viewModel?.ageSelection = .baby
    XCTAssertTrue(((viewModel?.searchText.isEmpty) != nil))
    XCTAssertEqual(viewModel?.ageSelection, .baby)
    XCTAssertEqual(viewModel?.typeSelection, AnimalSearchType.none)
    XCTAssertTrue(((viewModel?.shouldFilter) != nil))
  }

  func testShouldFilterIsTrueForTypeFilter() {
    viewModel?.typeSelection = .cat
    XCTAssertTrue(((viewModel?.searchText.isEmpty) != nil))
    XCTAssertEqual(viewModel?.ageSelection, AnimalSearchAge.none)
    XCTAssertEqual(viewModel?.typeSelection, .cat)
    XCTAssertTrue(((viewModel?.shouldFilter) != nil))
  }

  func testClearFiltersSearchTextIsNotEmpty() {
    viewModel?.typeSelection = .cat
    viewModel?.ageSelection = .baby
    viewModel?.searchText = "Kiki"
    viewModel?.clearFilters()

    XCTAssertFalse(((viewModel?.searchText.isEmpty) == nil))
    XCTAssertEqual(viewModel?.ageSelection, AnimalSearchAge.none)
    XCTAssertEqual(viewModel?.typeSelection, AnimalSearchType.none)
    XCTAssertTrue(((viewModel?.shouldFilter) != nil))
  }

  func testClearFiltersSearchTextIsEmpty() {
    viewModel?.typeSelection = .cat
    viewModel?.ageSelection = .baby
    viewModel?.clearFilters()

    XCTAssertTrue(((viewModel?.searchText.isEmpty) != nil))
    XCTAssertEqual(viewModel?.ageSelection, AnimalSearchAge.none)
    XCTAssertEqual(viewModel?.typeSelection, AnimalSearchType.none)
    XCTAssertFalse(((viewModel?.shouldFilter) == nil))
  }

  func testSelectTypeSuggestion() {
    viewModel?.selectTypeSuggestion(.cat)

    XCTAssertTrue(((viewModel?.searchText.isEmpty) != nil))
    XCTAssertEqual(viewModel?.ageSelection, AnimalSearchAge.none)
    XCTAssertEqual(viewModel?.typeSelection, .cat)
    XCTAssertTrue(((viewModel?.shouldFilter) != nil))
  }
}

