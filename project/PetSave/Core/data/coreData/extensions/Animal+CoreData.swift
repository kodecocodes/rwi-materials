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

extension AnimalEntity {
  
  var age: Age {
    set {
      self.ageValue = newValue.rawValue
    }
    get {
      Age(rawValue: self.ageValue!)!
    }
  }
  
  var coat: Coat {
    set {
      self.coatValue = newValue.rawValue
    }
    get {
      Coat(rawValue: self.coatValue!)!
    }
  }
  
  var gender: Gender {
    set {
      self.genderValue = newValue.rawValue
    }
    get {
      Gender(rawValue: self.genderValue!)!
    }
  }
  
  var size: Size {
    set {
      self.sizeValue = newValue.rawValue
    }
    get {
      Size(rawValue: self.sizeValue!)!
    }
  }
  
  var status: AdoptionStatus {
    set {
      self.statusValue = newValue.rawValue
    }
    get {
      AdoptionStatus(rawValue: self.statusValue!)!
    }
  }
  

  
}

extension Animal: UUIDIdentifiable {

  
  
//  init(managedObject: AnimalEntity) {
//    
//    self.age = managedObject.age
//    self.coat = managedObject.coat
//    self.description = managedObject.desc
//    self.distance = managedObject.distance
//    self.gender = managedObject.gender
//    self.id = Int(managedObject.id)
//    self.name = managedObject.name!
//    self.organizationId = managedObject.organizationId
//    self.publishedAt = managedObject.publishedAt?.description
//    self.size = managedObject.size
//    self.species = managedObject.species
//    self.status = managedObject.status
//    self.tags = []
//    self.type = managedObject.type!
//    self.url = managedObject.url
//    
//    self.attributes = AnimalAttributes(managedObject: managedObject.attributes!)
//
//    self.colors = APIColors(managedObject: managedObject.colors!)
//    self.contact = Contact(managedObject: managedObject.contact!)
//    self.environment = AnimalEnvironment(managedObject: managedObject.environment!)
//    
//    self.photos = managedObject.photos?.allObjects as! [PhotoSizes]
//    self.videos = managedObject.videos?.allObjects as! [VideoLink]
//
//    self.breeds = Breed(managedObject: managedObject.breeds!)
//    
//  }

  mutating func toManagedObject(context: NSManagedObjectContext) {
    let persistedValue = AnimalEntity.init(context: context)
    persistedValue.age = self.age
    persistedValue.coat = self.coat!
    persistedValue.desc = self.description
    persistedValue.distance = self.distance!
    persistedValue.gender = self.gender
    persistedValue.id = Int64(self.id!)
    persistedValue.name = self.name
    persistedValue.organizationId = self.organizationId
    persistedValue.publishedAt = self.publishedAt
    persistedValue.size = self.size
    persistedValue.species = self.species
    persistedValue.status = self.status
    persistedValue.type = self.type
    persistedValue.url = self.url
    persistedValue.attributes = self.attributes.toManagedObject(context: context)
    persistedValue.colors = self.colors.toManagedObject(context: context)
    persistedValue.contact = self.contact.toManagedObject(context: context)
    persistedValue.environment = self.environment?.toManagedObject(context: context)
    persistedValue.photos = NSSet(array: self.photos)
    persistedValue.videos = NSSet(array: self.videos)
    persistedValue.breeds = self.breeds.toManagedObject(context: context)

  }
  
}
