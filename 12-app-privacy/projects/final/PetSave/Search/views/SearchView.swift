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

import SwiftUI

struct SearchView: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \AnimalEntity.timestamp, ascending: true)
    ],
    animation: .default
  )
  private var animals: FetchedResults<AnimalEntity>

  @StateObject var viewModel = SearchViewModel(
    animalSearcher: AnimalSearcherService(requestManager: RequestManager()),
    animalStore: AnimalStoreService(
      context: PersistenceController.shared.container.newBackgroundContext()
    )
  )

  var filteredAnimals: [AnimalEntity] {
    guard viewModel.shouldFilter else { return [] }
    return filterAnimals()
  }

  @State var filterPickerIsPresented = false

  private var filterAnimals: FilterAnimals {
    FilterAnimals(
      animals: animals,
      query: viewModel.searchText,
      age: viewModel.ageSelection,
      type: viewModel.typeSelection
    )
  }

  var body: some View {
    NavigationView {
      AnimalListView(animals: filteredAnimals)
        .navigationTitle("Find your future pet")
        .searchable(
          text: $viewModel.searchText,
          placement: .navigationBarDrawer(displayMode: .always)
        )
        .onChange(of: viewModel.searchText) { _ in
          viewModel.search()
        }
        .overlay {
          if filteredAnimals.isEmpty && !viewModel.searchText.isEmpty {
            EmptyResultsView(query: viewModel.searchText)
          }
        }
        .toolbar {
          ToolbarItem {
            Button {
              filterPickerIsPresented.toggle()
            } label: {
              Label("Filter", systemImage: "slider.horizontal.3")
            }
            .sheet(isPresented: $filterPickerIsPresented) {
              NavigationView {
                SearchFilterView(viewModel: viewModel)
              }
            }
          }
        }
        .overlay {
          if filteredAnimals.isEmpty && viewModel.searchText.isEmpty {
            SuggestionsGrid(suggestions: AnimalSearchType.suggestions) { suggestion in
              viewModel.selectTypeSuggestion(suggestion)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
          }
        }
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(
      viewModel: SearchViewModel(
        animalSearcher: AnimalSearcherMock(),
        animalStore: AnimalStoreService(
          context: PersistenceController.preview.container.viewContext
        )
      )
    )
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
  }
}
