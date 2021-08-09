///// Copyright (c) 2021 Razeware LLC
///// 
///// Permission is hereby granted, free of charge, to any person obtaining a copy
///// of this software and associated documentation files (the "Software"), to deal
///// in the Software without restriction, including without limitation the rights
///// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
///// copies of the Software, and to permit persons to whom the Software is
///// furnished to do so, subject to the following conditions:
///// 
///// The above copyright notice and this permission notice shall be included in
///// all copies or substantial portions of the Software.
///// 
///// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
///// distribute, sublicense, create a derivative work, and/or sell copies of the
///// Software in any work that is designed, intended, or marketed for pedagogical or
///// instructional purposes related to programming, coding, application development,
///// or information technology.  Permission for such use, copying, modification,
///// merger, publication, distribution, sublicensing, creation of derivative works,
///// or sale is expressly withheld.
///// 
///// This project and source code may use libraries or frameworks that are
///// released under various Open-Source licenses. Use of those libraries and
///// frameworks are governed by their own individual licenses.
/////
///// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
///// THE SOFTWARE.
//
// import Foundation
// import CoreData
//
//
// @propertyWrapper struct PersistableCollection<StructType: UUIDIdentifiable & Codable, ManagedObject: NSManagedObject> : Codable {
//
//  private var context: NSManagedObjectContext
//
//  var wrappedValue: [StructType]? {
//
//    didSet { /*_ = convertToManagedObject(wrappedValue!)*/ }
//
//  }
//
//  init(context: NSManagedObjectContext) {
//    self.context = context
//
//  }
//
//  init(context: NSManagedObjectContext, wrappedValue: [StructType]) {
//    self.context = context
//    self.wrappedValue = wrappedValue
//  }
//
//  init(wrappedValue: [StructType]?) {
//    self.context = PersistenceController.shared.container.viewContext
//    self.wrappedValue = wrappedValue
//  }
//
//  func encode(to encoder: Encoder) throws {
//    try wrappedValue?.encode(to: encoder)
//  }
//
//  init(from decoder: Decoder) throws {
//    self.context = PersistenceController.shared.container.viewContext
//    self.wrappedValue = try [StructType].init(from: decoder)
//  }
//
//
//  func convertToManagedObject(_ valueType: [StructType]) -> NSManagedObject {
//
////    let persistedValue: NSManagedObject!
//    let persistedValue = ManagedObject.init(context: context)
////    if let _ = valueType.id {
////      persistedValue = fetchItemForValueType(valueType)
////    } else {
////      persistedValue = makeNewManagedObject(valueType)
////    }
//    return persistedValue
//  }
//
//  func fetchItemForValueType(_ valueType: [StructType]) -> NSManagedObject {
//    print("fetching collection for type")
////    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ManagedObject.self))
////    fetchRequest.predicate = NSPredicate(format: "id == %d", valueType.id!)
//    let persistedValue = ManagedObject.init(context: context)
////    if let results = try? context.fetch(fetchRequest),
////       let firstResult = results.first as? ManagedObject
////    {
////      print("got result, mirroring")
////      let mirror = Mirror(reflecting: valueType)
////      for case let (label?, value) in mirror.children {
////        firstResult.setValue(value, forKey: label)
////      }
////      persistedValue = firstResult
////    }
////    else {
////      return makeNewManagedObject(valueType)
////    }
//    return persistedValue
//  }
//
//  func makeNewManagedObject(_ valueType: [StructType]) -> NSManagedObject {
//
//    print("Creating new collection instance")
//    let persistedValue = ManagedObject.init(context: context)
////    print("new value is \(String(describing: persistedValue))")
////    let mirror = Mirror(reflecting: valueType)
////    print("mirror is \(mirror), number of children \(mirror.children.count)")
////    for case let (label?, value) in mirror.children {
////      print("updating label \(label) for value \(value)")
////      let valueMirror = Mirror(reflecting: value)
////      var labelString = label
////      if label.starts(with: "_") {
////        labelString = label.dropFirst(1).description
////      }
////      if persistedValue.entity.propertiesByName.keys.contains(labelString) == false {
////        labelString = labelString + "Value"
////      }
////      print("label string is \(labelString) and display style \(String(describing: valueMirror.displayStyle))")
////
////      if (valueMirror.displayStyle == .struct) {
//////        let type: Any.Type = valueMirror.subjectType
////        print("encountered struct")
////        persistedValue.setValue(value, forKey: labelString)
//////        let valueType = valueMirror.subjectType
//////        let structValue = value as valueMirror.subjectType
//////        @Persistable var pValue = value
////
////////          @Persistable<valueMirror.subjectType, ManagedObject> var pValue:
////      } else {
////        if "\(value)" != "nil" {
////          if (valueMirror.displayStyle == .enum) {
////            persistedValue.setValue(valueMirror.children.first?.label, forKey: labelString)
////          }
////          else {
////            persistedValue.setValue(value, forKey: labelString)
////          }
////        }
////      }
////    }
//    return persistedValue
//  }
// }
//
////Chapter 3 - storing data, converting between structs and classes
// @propertyWrapper struct Persistable<StructType: UUIDIdentifiable & Codable, ManagedObject: NSManagedObject> : Codable {
//
//  private var context: NSManagedObjectContext
//
//  var wrappedValue: StructType? {
//
//    didSet {
//      _ = convertToManagedObject(wrappedValue!)
//    }
//
//  }
//
//  init(context: NSManagedObjectContext) {
//    self.context = context
//
//  }
//
//  init(context: NSManagedObjectContext, wrappedValue: StructType) {
//    self.context = context
//    self.wrappedValue = wrappedValue
//  }
//
//  init(wrappedValue: StructType?) {
//    self.context = PersistenceController.shared.container.viewContext
//    self.wrappedValue = wrappedValue
//  }
//
////  enum CodingKeys: String, CodingKey {
////    case context
////    case wrappedValue
////  }
//
//  func encode(to encoder: Encoder) throws {
//    try wrappedValue?.encode(to: encoder)
//  }
//
//  init(from decoder: Decoder) throws {
//    self.context = PersistenceController.shared.container.viewContext
//    self.wrappedValue = try StructType.init(from: decoder)
//  }
//
//
//  func convertToManagedObject(_ valueType: StructType) -> NSManagedObject {
//
//    let persistedValue: NSManagedObject!
//    print("convertToManagedObject: number of inserted objects \(context.insertedObjects.count)")
//    if let _ = valueType.id {
//      persistedValue = fetchItemForValueType(valueType)
//    } else {
//      print("convertToManagedObject: before making new number of inserted objects \(context.insertedObjects.count)")
//      persistedValue = makeNewManagedObject(valueType)
//      print("convertToManagedObject: after making new number of inserted objects \(context.insertedObjects.count)")
//    }
//    return persistedValue
////    print("value type id is \(valueType.id) for \(String(describing: ManagedObject.self))")
////    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ManagedObject.self))
////    fetchRequest.predicate = NSPredicate(format: "id == %d", valueType.id)
////    let persistedValue: NSManagedObject!
////    if let results = try? context.fetch(fetchRequest),
////       let firstResult = results.first as? ManagedObject
////    {
////      print("got result, mirroring")
////      let mirror = Mirror(reflecting: valueType)
////      for case let (label?, value) in mirror.children {
////        firstResult.setValue(value, forKey: label)
////      }
////      persistedValue = firstResult
////    }
////    else {
////      persistedValue = makeNewManagedObject(valueType)
////    }
////    return persistedValue
//
//  }
//
//  func fetchItemForValueType(_ valueType: StructType) -> NSManagedObject {
//    print("fetching item for type")
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ManagedObject.self))
//    fetchRequest.predicate = NSPredicate(format: "id == %d", valueType.id!)
//    var persistedValue: NSManagedObject // = ManagedObject.init(context: context)
//    if let results = try? context.fetch(fetchRequest),
//       let firstResult = results.first as? ManagedObject
//    {
//      print("got result, mirroring")
//      let mirror = Mirror(reflecting: valueType)
//      for case let (label?, value) in mirror.children {
//        firstResult.setValue(value, forKey: label)
//      }
//      persistedValue = firstResult
//    }
//    else {
//      return makeNewManagedObject(valueType)
//    }
//    return persistedValue
//  }
//
//  func makeNewManagedObject(_ valueType: StructType) -> NSManagedObject {
//
//    print("Creating new instance")
////    print("number of inserted objects \(context.insertedObjects.count)")
////    print("first object \(context.insertedObjects.first)")
//
//    let persistedValue = ManagedObject.init(context: context)
////    print("number of inserted objects \(context.insertedObjects.count)")
////
////    print("new value is \(String(describing: persistedValue))")
////    print("number of inserted objects \(context.insertedObjects.count)")
//
//    let mirror = Mirror(reflecting: valueType)
////    print("mirror is \(mirror), number of children \(mirror.children.count)")
////    print("number of inserted objects \(context.insertedObjects.count)")
//
//    for case let (label?, value) in mirror.children {
//      print("updating label \(label) for value \(value)")
//      let valueMirror = Mirror(reflecting: value)
//      var labelString = label
//      if label.starts(with: "_") {
//        labelString = label.dropFirst(1).description
//      }
//      if persistedValue.entity.propertiesByName.keys.contains(labelString) == false {
//        labelString = labelString + "Value"
//      }
//      print("label string is \(labelString) and display style \(String(describing: valueMirror.displayStyle))")
//
//      if (valueMirror.displayStyle == .struct) {
////        let type: Any.Type = valueMirror.subjectType
//        print("encountered struct \(value)")
////        persistedValue.setPersistableValue(value, forKey: labelString)
////        let valueType = valueMirror.subjectType
////        let structValue = value as valueMirror.subjectType
////        @Persistable var pValue = value
//
//////          @Persistable<valueMirror.subjectType, ManagedObject> var pValue:
//      } else {
//        print("value is \(value)")
//        if "\(value)" != "nil" {
//          if (valueMirror.displayStyle == .enum) {
//            print("number of children \(valueMirror.children.count)")
//            print("saving \(labelString) \(value)")
//            persistedValue.setValue("\(value)", forKey: labelString)
//          }
//          else {
//            persistedValue.setValue(value, forKey: labelString)
//            print("new value is \(String(describing: persistedValue))")
//          }
//        }
//      }
//    }
////    print("number of inserted objects \(context.insertedObjects.count)")
////    print("persisted value name \(persistedValue.value(forKey: "name"))")
////    do {
////      try context.save()
////    } catch {
////      print("error saving \(error)")
////    }
//    return persistedValue
//  }
// }
