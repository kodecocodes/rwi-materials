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

protocol AnimalSearcher {
  func searchAnimal(
    by text: String,
    age: AnimalSearchAge,
    type: AnimalSearchType
  ) async -> [Animal]
}

final class SearchViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var ageSelection = AnimalSearchAge.none
  @Published var typeSelection = AnimalSearchType.none
  
  //Chapter 3 - Fetching Data - likely to replace the animals array below - the Data API will pull results, store them in the database, and then this sectioned fetch request will help keep the UI up to date
  /*
   @SectionedFetchRequest<String, Animal>(
   
    sectionIdentifier: \.breed,
    sortDescriptors: [NSSortDescriptor(keyPath: \Animal.name, ascending: true)],
    animation: .default
   ) private var animals
   
   */
  
  @Published var animals: [Animal] = []
  
  private let animalSearcher: AnimalSearcher
  
  init(animalSearcher: AnimalSearcher) {
    self.animalSearcher = animalSearcher
  }
  
  func search() {
    Task {
      let animals = await animalSearcher.searchAnimal(
        by: searchText,
        age: ageSelection,
        type: typeSelection
      )
      await update(animals: animals)
    }
  }
  
  func selectTypeSuggestion(_ type: AnimalSearchType) {
    typeSelection = type
    search()
  }

  //TODO: Once this is hooked into the DataAPI -> Database -> Fetchrequest scenario described above, we may not need all of this

  @MainActor
  func update(animals: [Animal]) {
    self.animals = animals
  }
}
