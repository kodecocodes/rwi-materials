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

import SwiftUI

//Chapter 10: Animation here while data is loading, replacing ProgressView

struct AnimalsNearYouView: View {
  @ObservedObject var viewModel: AnimalsNearYouViewModel

  #if !DEBUG
  @SectionedFetchRequest<String, AnimalEntity>(
    sectionIdentifier: \.breed,
    sortDescriptors: [NSSortDescriptor(keyPath: \AnimalEntity.name, ascending: true)],
    animation: .default
  ) private var sectionedAnimals : SectionedFetchResults<String, AnimalEntity>
  #endif

  var body: some View {
      ScrollView {
        #if DEBUG
        AnimalsGrid(animals: viewModel.animals)
        #else
        ForEach(sectionedAnimals) { animals in
          Section(header: Text(animals.id)) {
            AnimalsGrid(animals: animals.reversed())
          }
        }
        #endif
        if viewModel.isFetchingMoreAnimals {
          ProgressView("Finding more animals...")
        } else {
          Button("Load more", action: viewModel.fetchMoreAnimals)
            .opacity(viewModel.showMoreButtonOpacity)
            .buttonStyle(.bordered)
            .tint(.blue)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
        }
      }
      .navigationTitle("Animals near you")
      .overlay {
        if viewModel.isLoading {
          ProgressView("Finding Animals near you...")
        }
      }
      .task(viewModel.fetchAnimals)
  }
}

#if DEBUG

#warning("Remove later, only for testing purposes...")
struct AnimalFetcherMock: AnimalsFetcher {
  func fetchAnimals(page: Int) async -> [Animal] {
    await Task.sleep(2)
    return Animal.mock
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AnimalsNearYouView(
        viewModel: AnimalsNearYouViewModel(
          isLoading: true,
          animalFetcher: AnimalFetcherMock()
        )
      )
    }
    
    NavigationView {
      AnimalsNearYouView(
        viewModel: AnimalsNearYouViewModel(
          isLoading: true,
          animalFetcher: AnimalFetcherMock()
        )
      )
    }
    .preferredColorScheme(.dark)
  }
}
#else

//#warning("Remove later, only for testing purposes...")
//struct AnimalFetcherDatabaseMock: AnimalsFetcher {
//  func fetchAnimals(page: Int) async -> [AnimalEntity] {
//    await Task.sleep(2)
//    return CoreDataHelper.getTestAnimals()
//  }
//}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AnimalsNearYouView(
        viewModel: AnimalsNearYouViewModel(
          animalFetcher: FetchAnimalsService()
        )
      )
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }

    NavigationView {
      AnimalsNearYouView(
        viewModel: AnimalsNearYouViewModel(
          animalFetcher: FetchAnimalsService()
        )
      )
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .preferredColorScheme(.dark)
  }
}
#endif


