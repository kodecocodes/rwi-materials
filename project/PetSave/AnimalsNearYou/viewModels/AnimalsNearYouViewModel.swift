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

protocol AnimalFetcher {
  func fetchAnimals(page: Int) async -> [Animal]
}

final class AnimalsNearYouViewModel: ObservableObject {
  
  //Chapter 3 - Fetching Data - likely to replace the animals array below - the Data API will pull results, store them in the database, and then this sectioned fetch request will help keep the UI up to date
  /*
   @SectionedFetchRequest<String, Animal>(
   
    sectionIdentifier: \.breed,
    sortDescriptors: [NSSortDescriptor(keyPath: \Animal.name, ascending: true)],
    animation: .default
   ) private var animals
   
   */
  
  @Published var animals: [Animal] {
    didSet {
      print(animals)
    }
  }
  @Published var isLoading: Bool
  
  var page = 1
  
  private let animalFetcher: AnimalFetcher
  
  init(
    animals: [Animal] = [],
    isLoading: Bool = true,
    animalFetcher: AnimalFetcher
  ) {
    self.animals = animals
    self.isLoading = isLoading
    self.animalFetcher = animalFetcher
  }
  
  func fetchAnimals() async {
    // .task() is called everytime the view appears, even when you switch tabs...
//    guard animals.isEmpty else { return }
    DispatchQueue.main.async { self.isLoading = true }
    //self.page += page
    let animals = await animalFetcher.fetchAnimals(page: self.page)
//    await updateAnimals(animals: animals)
    await addAnimals(animals: animals)
  }
  
  func performNextAnimalFetch() async {
    DispatchQueue.main.async { self.isLoading = true }
    self.page += 1
    let animals = await animalFetcher.fetchAnimals(page: self.page)
    await updateAnimals(animals: animals)
  }
  
  //TODO: Once this is hooked into the DataAPI -> Database -> Fetchrequest scenario described above, we may not need all of this
  @MainActor
  func updateAnimals(animals: [Animal]) {
    self.animals += animals
    isLoading = false
  }
  
  @MainActor
  func addAnimals(animals: [Animal]) {
    self.animals = animals
    isLoading = false
  }
}
