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

protocol AnimalsFetcher {
  func fetchAnimals(page: Int) async -> [Animal]
}

final class AnimalsNearYouViewModel: ObservableObject {


  @Published var isLoading: Bool
  @Published var isFetchingMoreAnimals = false

  var page = 1
  
  private let animalFetcher: AnimalsFetcher

  #if DEBUG
  @Published var animals: [Animal]

  init(animals: [Animal] = [],
       isLoading: Bool = true,
       animalFetcher: AnimalsFetcher) {
    self.animals = animals
    self.isLoading = isLoading
    self.animalFetcher = animalFetcher
  }

  #else
  let context = PersistenceController.shared.container.viewContext

  init(isLoading: Bool = true,
       animalFetcher: AnimalsFetcher) {
    self.isLoading = isLoading
    self.animalFetcher = animalFetcher
  }
  #endif

  #if DEBUG
  var showMoreButtonOpacity: Double {
    animals.isEmpty ? 0 : 1
  }
  #else
  var showMoreButtonOpacity: Double {
    1
  }
  #endif

  #if DEBUG
  func fetchAnimals() async {
    // .task() is called everytime the view appears, even when you switch tabs...
    guard animals.isEmpty else { return }
    let animals = await animalFetcher.fetchAnimals(page: page)
    print("number of animals \(animals.count)")
    await updateAnimals(animals: animals)
  }
  #else
  func fetchAnimals() async {
    // .task() is called everytime the view appears, even when you switch tabs...
    DispatchQueue.main.async { self.isLoading = true }
    let animals = await animalFetcher.fetchAnimals(page: page)
    await addAnimals(animals: animals)
    do {
      try context.save()
    } catch {
      print("Error saving to database \(error)")
    }
  }
  #endif

  #if DEBUG
  func fetchMoreAnimals() {
    isFetchingMoreAnimals = true
    Task {
      page += 1
      let animals = await animalFetcher.fetchAnimals(page: page)
      await updateAnimals(animals: animals)
    }
  }
  #else
  func fetchMoreAnimals() {
    isFetchingMoreAnimals = true
    Task {
      page += 1
      let animals = await animalFetcher.fetchAnimals(page: page)
      await addAnimals(animals: animals)
//      DispatchQueue.main.async { self.isFetchingMoreAnimals = false }
    }
  }
  #endif


  #if DEBUG
  @MainActor
  func updateAnimals(animals: [Animal]) {
    self.animals += animals
    isLoading = false
    isFetchingMoreAnimals = false
  }
  #else
  @MainActor
  func addAnimals(animals: [Animal]) {
    for var animal in animals {
      animal.toManagedObject(context: context)
    }
    isLoading = false
  }
  #endif
}
