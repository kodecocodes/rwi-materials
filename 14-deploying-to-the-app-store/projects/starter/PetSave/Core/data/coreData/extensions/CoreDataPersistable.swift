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

import CoreData

protocol UUIDIdentifiable: Identifiable {
  var id: Int? { get set }
}

protocol CoreDataPersistable: UUIDIdentifiable {
  associatedtype ManagedType
  init()
  init(managedObject: ManagedType?)
  var keyMap: [PartialKeyPath<Self>: String] { get }
  mutating func toManagedObject(context: NSManagedObjectContext) -> ManagedType

  func save(context: NSManagedObjectContext) throws
}

// MARK: - Managed Object
extension CoreDataPersistable where ManagedType: NSManagedObject {
  init(managedObject: ManagedType?) {
    self.init()
    guard let managedObject = managedObject else { return }
    for attribute in managedObject.entity.attributesByName {  // this gets attributes, not relationships
      if let keyP = keyMap.first(where: { $0.value == attribute.key })?.key {
        let value = managedObject.value(forKey: attribute.key)
        storeValue(value, toKeyPath: keyP)
      }
    }
  }

  private mutating func storeValue(_ value: Any?, toKeyPath partial: AnyKeyPath) {
    switch partial {
    case let keyPath as WritableKeyPath<Self, URL?>:
      self[keyPath: keyPath] = value as? URL
    case let keyPath as WritableKeyPath<Self, Int?>:
      self[keyPath: keyPath] = value as? Int
    case let keyPath as WritableKeyPath<Self, String?>:
      self[keyPath: keyPath] = value as? String
    case let keyPath as WritableKeyPath<Self, Bool?>:
      self[keyPath: keyPath] = value as? Bool

    default:
      return
    }
  }

  mutating func toManagedObject(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> ManagedType {
    let persistedValue: ManagedType
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

    return setValuesFromMirror(persistedValue: persistedValue)
  }

  private func setValuesFromMirror(persistedValue: ManagedType) -> ManagedType {
    let mirror = Mirror(reflecting: self)
    for case let (label?, value) in mirror.children {
      let value2 = Mirror(reflecting: value)
      if value2.displayStyle != .optional || !value2.children.isEmpty {
        persistedValue.setValue(value, forKey: label)
      }
    }

    return persistedValue
  }

  func save(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
    try context.save()
  }
}
