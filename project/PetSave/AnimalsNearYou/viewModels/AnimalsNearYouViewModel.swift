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
import CoreLocation

protocol AnimalsFetcher {
  func fetchAnimals(page: Int, location: CLLocation?) async -> [Animal]
}

final class AnimalsNearYouViewModel: ObservableObject {
  @Published var isLoading: Bool
  @Published var hasMoreAnimals = true

  var page = 1

  private let animalFetcher: AnimalsFetcher
  private let animalsRepository: AnimalsRepositoryProtocol
  private let locationManager: LocationManager

  init(
    isLoading: Bool = true,
    animalFetcher: AnimalsFetcher,
    animalsRepository: AnimalsRepositoryProtocol,
    locationManager: LocationManager
  ) {
    self.isLoading = isLoading
    self.animalFetcher = animalFetcher
    self.animalsRepository = animalsRepository
    self.locationManager = locationManager
  }

  private var userLocation: CLLocation? {
    let userLocationIsEnabled = locationManager.useUserLocation && !locationManager.locationIsDisabled
    return userLocationIsEnabled ? locationManager.userLocation : nil
  }

  func fetchAnimals() async {
    let animals = await requestAnimals()
    await addAnimals(animals: animals)
  }

  func fetchMoreAnimals() {
    Task {
      page += 1
      let animals = await requestAnimals()
      await addAnimals(animals: animals)
    }
  }

  func requestAnimals() async -> [Animal] {
    await animalFetcher.fetchAnimals(
      page: page,
      location: userLocation
    )
  }

  func refresh() {
    CoreDataHelper.clearDatabase()
    hasMoreAnimals = true
    page = 1
    Task {
      await fetchAnimals()
    }
  }

  @MainActor
  func addAnimals(animals: [Animal]) {
    hasMoreAnimals = !animals.isEmpty
    isLoading = false
    do {
      try animalsRepository.saveAnimals(animals: animals)
    } catch {
      #warning("Handle later some other way...")
      print("Error saving animals \(error.localizedDescription)")
    }
  }
}

#warning("Remove later, only for testing purposes...")
struct AnimalFetcherMock: AnimalsFetcher {
  func fetchAnimals(page: Int, location: CLLocation?) async -> [Animal] {
    await Task.sleep(2)
    return Animal.mock
  }
}

struct AnimalsRepositoryMock: AnimalsRepositoryProtocol {
  func saveAnimals(animals: [Animal]) throws {
    let context = PersistenceController.preview.container.viewContext
    for var animal in animals {
      animal.toManagedObject(context: context)
    }
    try? context.save()
  }
}
