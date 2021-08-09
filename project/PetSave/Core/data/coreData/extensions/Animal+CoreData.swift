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
    get {
      Age(rawValue: ageValue!)!
    }
    set {
      self.ageValue = newValue.rawValue
    }
  }

  var coat: Coat {
    get {
      Coat(rawValue: coatValue!)!
    }
    set {
      self.coatValue = newValue.rawValue
    }
  }

  var gender: Gender {
    get {
      Gender(rawValue: genderValue!)!
    }
    set {
      self.genderValue = newValue.rawValue
    }
  }

  var size: Size {
    get {
      Size(rawValue: sizeValue!)!
    }
    set {
      self.sizeValue = newValue.rawValue
    }
  }

  var status: AdoptionStatus {
    get {
      AdoptionStatus(rawValue: statusValue!)!
    }
    set {
      self.statusValue = newValue.rawValue
    }
  }

  @objc var breed: String {
    return breeds?.primary ?? breeds?.secondary ?? ""
  }

  var picture: URL? {
    #warning("I disabled the rule because NSSet does not have a propery 'isEmpty'. Check with FPE about this.")
    // swiftlint:disable:next empty_count
    guard let photos = photos, photos.count > 0 else { return nil }
    let photosArray = photos.allObjects as! [PhotoSizesEntity]
    guard let firstPhoto = photosArray.first else { return nil }
    let pic = firstPhoto.medium ?? firstPhoto.full
    return pic
  }

  var phoneLink: URL? {
    guard let phoneNumber = contact?.phone else { return nil }
    let formattedPhoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
      .replacingOccurrences(of: ")", with: "")
      .replacingOccurrences(of: "-", with: "")
      .replacingOccurrences(of: " ", with: "")
    return URL(string: "tel:\(formattedPhoneNumber)")
  }

  var emailLink: URL? {
    guard let emailAddress = contact?.email else { return nil }
    return URL(string: "mailto:\(emailAddress)")
  }

  var address: String {
    guard let address = contact?.address else { return "No address" }
    return [
      address.address1,
      address.address2,
      address.city,
      address.state,
      address.postcode,
      address.country
    ]
    .compactMap { $0 }
    .joined(separator: ", ")
  }
}

extension Animal: UUIDIdentifiable {
  init(managedObject: AnimalEntity) {
    self.age = managedObject.age
    self.coat = managedObject.coat
    self.description = managedObject.desc
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
    self.colors = APIColors(managedObject: managedObject.colors!)
    self.contact = Contact(managedObject: managedObject.contact!)
    self.environment = AnimalEnvironment(managedObject: managedObject.environment!)
    self.photos = (managedObject.photos?.allObjects as! [PhotoSizesEntity]).map { PhotoSizes(managedObject: $0) }
    self.videos = (managedObject.videos?.allObjects as! [VideoLinkEntity]).map { VideoLink(managedObject: $0) }
    self.breeds = Breed(managedObject: managedObject.breeds!)
  }

  private func checkForExistingAnimal(id: Int, context: NSManagedObjectContext) -> Bool {
    let fetchRequest = AnimalEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %d", id)

    if let results = try? context.fetch(fetchRequest), results.first != nil {
      return true
    }
    return false
  }

  mutating func toManagedObject(context: NSManagedObjectContext) {
    guard checkForExistingAnimal(id: self.id!, context: context) == false else { return }
    let persistedValue = AnimalEntity.init(context: context)
    persistedValue.timestamp = Date()
    persistedValue.age = self.age
    persistedValue.coat = self.coat ?? .short
    persistedValue.desc = self.description
    persistedValue.distance = self.distance ?? 0
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
    persistedValue.addToPhotos(NSSet(array: self.photos.map { (photo: PhotoSizes) -> PhotoSizesEntity in
      var mutablePhoto = photo
      return mutablePhoto.toManagedObject(context: context)
    }))
    persistedValue.addToVideos(NSSet(array: self.videos.map { (video: VideoLink) -> VideoLinkEntity in
      var mutableVideo = video
      return mutableVideo.toManagedObject(context: context)
    }))
    persistedValue.breeds = self.breeds.toManagedObject(context: context)
  }
}
