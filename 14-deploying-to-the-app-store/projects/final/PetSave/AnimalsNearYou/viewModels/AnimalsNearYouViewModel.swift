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

import Foundation
import CoreLocation

protocol AnimalsFetcher {
  func fetchAnimals(
    page: Int,
    latitude: Double?,
    longitude: Double?
  ) async -> [Animal]
}

protocol AnimalStore {
  func save(animals: [Animal]) async throws
}

@MainActor
final class AnimalsNearYouViewModel: ObservableObject {
  @Published var isLoading: Bool
  @Published var hasMoreAnimals = true
  private let animalFetcher: AnimalsFetcher
  private let animalStore: AnimalStore

  private(set) var page = 1

  init(
    isLoading: Bool = true,
    animalFetcher: AnimalsFetcher,
    animalStore: AnimalStore
  ) {
    self.isLoading = isLoading
    self.animalFetcher = animalFetcher
    self.animalStore = animalStore
  }

  func fetchAnimals(location: CLLocation?) async {
    isLoading = true
    do {
      let animals = await animalFetcher.fetchAnimals(
        page: page,
        latitude: location?.coordinate.latitude,
        longitude: location?.coordinate.longitude
      )
      try await animalStore.save(animals: animals)
      hasMoreAnimals = !animals.isEmpty
    } catch {
      print("Error fetching animals... \(error.localizedDescription)")
    }
    isLoading = false
  }

  func fetchMoreAnimals(location: CLLocation?) async {
    page += 1
    await fetchAnimals(location: location)
  }
}
