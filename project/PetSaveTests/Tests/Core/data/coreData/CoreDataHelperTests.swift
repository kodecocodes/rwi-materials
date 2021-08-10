/// Copyright (c) 2021 Razeware LLC
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

// TODO: To be filled out, Chapter 3
class CoreDataHelperTests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    CoreDataHelper.clearDatabase()
    print("documents \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])")
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

//  func testPersistableField() throws {
//    
//    //Given
//    let mockedAnimal = Animal.mock[1]
//    let context = PersistenceController.shared.container.viewContext
//    CoreDataHelper.clearDatabase()
////    @Persistable<Animal, AnimalEntity>(context: context) var pet: Animal?
////    pet = mockedAnimal
//    @Persistable<Breed, BreedEntity>(context: context) var breed: Breed?
//    breed = mockedAnimal.breeds
//    
//    //When
//    let fetchRequest = BreedEntity.fetchRequest()
//      if let results = try? context.fetch(fetchRequest),
//         let persistedValue = results.first {
//        //Then
//        XCTAssert(persistedValue.primary == "Australian Cattle Dog / Blue Heeler", "Mock pet breed was expected to be Australian Cattle Dog / Blue Heeler but was \(String(describing: persistedValue.primary))")
//
//      } else {
//        return XCTFail("No results or empty set returned from database")
//      }
//  }
//
//  func testPersistableCompoundField() throws {
//
//    //Given
//    let context = PersistenceController.shared.container.viewContext
//
//    let mockedAnimal = Animal.mock[1]
//    try context.save()
//    let fetchRequest = BreedEntity.fetchRequest()
//    if let results = try? context.fetch(fetchRequest),
//       let persistedValue = results.first {
//      print("found a breed")
//    }
//
//    @Persistable<Animal, AnimalEntity>(context: context) var pet: Animal?
//
//    pet = mockedAnimal
//
//    try context.save()
//
//    //When
//    let fetchRequest2 = AnimalEntity.fetchRequest()
//      if let results = try? context.fetch(fetchRequest2),
//         let persistedValue = results.first {
//        //Then
//        XCTAssert(persistedValue.name == "ID#A405763", "Mock pet name was expected to be ID#A405763 but was \(String(describing: persistedValue.name))")
//
//      } else {
//        return XCTFail("No results or empty set returned from database")
//      }
//  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
