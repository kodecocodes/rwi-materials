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

import CoreData

enum CoreDataHelper {
  static let context = PersistenceController.shared.container.viewContext
  static let previewContext = PersistenceController.preview.container.viewContext

  static func clearDatabase() {
    let entities = PersistenceController.shared.container.managedObjectModel.entities
    entities.compactMap(\.name).forEach(clearTable)
  }

  private static func clearTable(_ entity: String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
      try context.execute(deleteRequest)
      try context.save()
    } catch {
      fatalError("\(#file), \(#function), \(error.localizedDescription)")
    }
  }
}

// MARK: - Deleting Data
extension Collection where Element == NSManagedObject, Index == Int {
  func delete(at indices: IndexSet, inViewContext viewContext: NSManagedObjectContext = CoreDataHelper.context) {
    indices.forEach { index in
      viewContext.delete(self[index])
    }

    do {
      try viewContext.save()
    } catch {
      fatalError("""
        \(#file), \
        \(#function), \
        \(error.localizedDescription)
      """)
    }
  }
}

// MARK: - Xcode Previews Content
extension CoreDataHelper {
  static func getTestAnimal() -> Animal? {
    let fetchRequest = AnimalEntity.fetchRequest()
    if let results = try? previewContext.fetch(fetchRequest),
      let first = results.first {
      return Animal(managedObject: first)
    }
    return nil
  }

  static func getTestAnimals() -> [Animal]? {
    let fetchRequest = AnimalEntity.fetchRequest()

    if let results = try? previewContext.fetch(fetchRequest), !results.isEmpty {
      return results.map(Animal.init(managedObject:))
    }
    return nil
  }

  static func getTestAnimalEntity() -> AnimalEntity? {
    let fetchRequest = AnimalEntity.fetchRequest()
    fetchRequest.fetchLimit = 1
    guard let results = try? previewContext.fetch(fetchRequest),
    let first = results.first else { return nil }
    return first
  }

  static func getTestAnimalEntities() -> [AnimalEntity]? {
    let fetchRequest = AnimalEntity.fetchRequest()
    guard let results = try? previewContext.fetch(fetchRequest),
      !results.isEmpty else { return nil }
    return results
  }
}
