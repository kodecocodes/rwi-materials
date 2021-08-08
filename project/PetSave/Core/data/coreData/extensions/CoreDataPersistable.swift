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

import Foundation
import CoreData

protocol CoreDataPersistable: UUIDIdentifiable {
  associatedtype ManagedType

  mutating func toManagedObject(context: NSManagedObjectContext) -> ManagedType

  func save(context: NSManagedObjectContext) throws
}

extension CoreDataPersistable where ManagedType: NSManagedObject {

  mutating func toManagedObject(context: NSManagedObjectContext) -> ManagedType {

    let persistedValue: ManagedType!
    if let id = self.id {
      let fetchRequest = ManagedType.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
      if let results = try? context.fetch(fetchRequest),
         let firstResult = results.first as? ManagedType {
        persistedValue = firstResult
      } else {
        persistedValue = ManagedType.init(context: context)
        self.id = persistedValue.value(forKey: "id") as? Int
      }
    } else {
      persistedValue = ManagedType.init(context: context)
      self.id = persistedValue.value(forKey: "id") as? Int
    }

    let mirror = Mirror(reflecting: self)
    for case let (label?, value) in mirror.children {
      let value2 = Mirror(reflecting: value)
      if value2.displayStyle != .optional || value2.children.count != 0 {
          persistedValue.setValue(value, forKey: label)
      }
    }

    return persistedValue
  }

  func save(context: NSManagedObjectContext) throws {

    try context.save()
  }
}

protocol UUIDIdentifiable: Identifiable {
  var id: Int? { get set }
}
