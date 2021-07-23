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

struct Animal: Codable, Identifiable {
  let id: Int
  let organizationId: String?
  let url: URL?
  let type: String
  let species: String?
  let breeds: Breed
  let colors: APIColors
  let age: Age
  let gender: Gender
  let size: Size
  let coat: Coat?
  let name: String
  let description: String?
  let photos: [PhotoSizes]
  let videos: [VideoLink]
  let status: AdoptionStatus
  let attributes: AnimalAttributes
  let environment: AnimalEnvironment?
  let tags: [String]
  let contact: Contact
  let publishedAt: String?
  let distance: Double?
}

extension Animal {
  var breed: String {
    breeds.primary ?? breeds.secondary ?? ""
  }
  
  var picture: URL? {
    photos.first?.medium ?? photos.first?.full
  }
  
  #warning("Move to Animal details model")
  var phoneLink: URL? {
    guard let phoneNumber = contact.phone else { return nil }
    let formattedPhoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
      .replacingOccurrences(of: ")", with: "")
      .replacingOccurrences(of: "-", with: "")
      .replacingOccurrences(of: " ", with: "")
    return URL(string: "tel:\(formattedPhoneNumber)")
  }
  
  var emailLink: URL? {
    URL(string: "mailto:\(contact.email)")
  }
  
  var address: String {
    let address = contact.address
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