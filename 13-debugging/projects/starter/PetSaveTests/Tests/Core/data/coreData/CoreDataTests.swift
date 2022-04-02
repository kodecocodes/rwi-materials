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
import CoreData

class CoreDataTests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  func testToManagedObject() throws {
    let previewContext = PersistenceController.preview.container.viewContext
    let fetchRequest = AnimalEntity.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AnimalEntity.name, ascending: true)]
    guard let results = try? previewContext.fetch(fetchRequest),
      let first = results.first else { return }

      XCTAssert(first.name == "CHARLA", """
        Pet name did not match, was expecting Kiki, got
        \(String(describing: first.name))
      """)
      XCTAssert(first.type == "Dog", """
        Pet type did not match, was expecting Cat, got
        \(String(describing: first.type))
      """)
      XCTAssert(first.coat.rawValue == "Short", """
        Pet coat did not match, was expecting Short, got
        \(first.coat.rawValue)
      """)
  }

  func testDeleteManagedObject() throws {
    let previewContext =
      PersistenceController.preview.container.viewContext

    let fetchRequest = AnimalEntity.fetchRequest()
    guard let results = try? previewContext.fetch(fetchRequest),
      let first = results.first else { return }

    let expectedResult = results.count - 1
    previewContext.delete(first)

    guard let resultsAfterDeletion = try? previewContext.fetch(fetchRequest)
      else { return }

    XCTAssertEqual(expectedResult, resultsAfterDeletion.count, """
      The number of results was expected to be \(expectedResult) after deletion, was \(results.count)
    """)
  }

  func testFetchManagedObject() throws {
    let previewContext = PersistenceController.preview.container.viewContext
    let fetchRequest = AnimalEntity.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "name == %@", "Ellie")
    guard let results = try? previewContext.fetch(fetchRequest),
      let first = results.first else { return }
    XCTAssert(first.name == "Ellie", """
      Pet name did not match, expecting Ellie, got
      \(String(describing: first.name))
    """)
  }
}
