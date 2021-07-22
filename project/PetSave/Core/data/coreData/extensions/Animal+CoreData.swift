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

extension Animal {
  
  init(managedObject: AnimalEntity) {
    
    self.age = managedObject.age
    self.coat = managedObject.coat
    self.desc = managedObject.desc
    self.distance = managedObject.distance
    self.gender = managedObject.gender
    self.id = Int(managedObject.id)
    self.name = managedObject.name!
    self.organizationId = managedObject.organizationId
    self.publishedAt = managedObject.publishedAt?.description
    self.size = managedObject.size
    self.species = managedObject.species
    self.status = managedObject.status
    self.tags = []
    self.type = managedObject.type!
    self.url = managedObject.url
    
    self.attributes = AnimalAttributes(managedObject: managedObject.attributes!)
    self.breeds = Breed(managedObject: managedObject.breeds!)
    self.colors = APIColors(managedObject: managedObject.colors!)
    self.contact = Contact(managedObject: managedObject.contact!)
    self.environment = AnimalEnvironment(managedObject: managedObject.environment!)
    
    self.photos = managedObject.photos?.allObjects as! [PhotoSizes]
    self.videos = managedObject.videos?.allObjects as! [VideoLink]
    
  }
  
  func toManagedObject(context: NSManagedObjectContext) -> AnimalEntity {
    
    let persistedValue = AnimalEntity.init(context: context)
    let mirror = Mirror(reflecting: self)
    for case let (label?, value) in mirror.children {
      persistedValue.setValue(value, forKey: label)
    }
    
    return persistedValue
  }
  
}
