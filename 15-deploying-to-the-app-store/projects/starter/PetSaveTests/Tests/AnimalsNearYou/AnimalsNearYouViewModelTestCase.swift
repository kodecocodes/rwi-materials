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

import Foundation
import XCTest
@testable import PetSave

@MainActor
final class AnimalsNearYouViewModelTestCase: XCTestCase {
  let testContext = PersistenceController.preview.container.viewContext
  // swiftlint:disable:next implicitly_unwrapped_optional
  var viewModel: AnimalsNearYouViewModel!

  @MainActor
  override func setUp() {
    super.setUp()
    viewModel = AnimalsNearYouViewModel(
      isLoading: true,
      animalFetcher: AnimalsFetcherMock(),
      animalStore: AnimalStoreService(context: testContext)
    )
  }

  func testFetchAnimalsLoadingState() async {
    XCTAssertTrue(viewModel.isLoading, "The view model should be loading, but it isn't")
    await viewModel.fetchAnimals(location: nil)
    XCTAssertFalse(viewModel.isLoading, "The view model shouldn't be loading, but it is")
  }

  func testUpdatePageOnFetchMoreAnimals() async {
    XCTAssertEqual(
      viewModel.page,
      1,
      "the view model's page property should be 1 before fetching, but it's \(viewModel.page)"
    )
    await viewModel.fetchMoreAnimals(location: nil)
    XCTAssertEqual(
      viewModel.page,
      2,
      "the view model's page property should be 2 after fetching, but it's \(viewModel.page)"
    )
  }

  func testFetchAnimalsEmptyResponse() async {
    viewModel = AnimalsNearYouViewModel(
      isLoading: true,
      animalFetcher: EmptyResponseAnimalsFetcherMock(),
      animalStore: AnimalStoreService(context: testContext)
    )
    await viewModel.fetchAnimals(location: nil)
    XCTAssertFalse(
      viewModel.hasMoreAnimals,
      "hasMoreAnimals should be false with an empty response, but it's true"
    )
    XCTAssertFalse(
      viewModel.isLoading,
      "the view model shouldn't be loading after receiving an empty response, but it is"
    )
  }
}

struct EmptyResponseAnimalsFetcherMock: AnimalsFetcher {
  func fetchAnimals(page: Int, latitude: Double?, longitude: Double?) async -> [Animal] {
    return []
  }
}
