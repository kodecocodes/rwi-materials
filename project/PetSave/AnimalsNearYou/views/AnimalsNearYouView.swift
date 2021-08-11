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

// Chapter 10: Animation here while data is loading, replacing ProgressView

struct AnimalsNearYouView: View {
  @ObservedObject var viewModel: AnimalsNearYouViewModel
  @State var settingsIsPresented = false

  //TODO: Track down why this doesn't work after first launch
//  @SectionedFetchRequest<String, AnimalEntity>(
//    sectionIdentifier: \breed,
//    sortDescriptors: [NSSortDescriptor(keyPath: \AnimalEntity.breed, ascending: true), NSSortDescriptor(keyPath: \AnimalEntity.timestamp, ascending: true)],
//    animation: .default
//  ) private var sectionedAnimals: SectionedFetchResults<String, AnimalEntity>

  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \AnimalEntity.timestamp, ascending: true)
    ],
    animation: .default
  )
  var animals: FetchedResults<AnimalEntity>

  var body: some View {
//    let _  = print("sec fetch count \(sectionedAnimals.count)")
    List {
//      ForEach(sectionedAnimals) { animals in
//        Section(header: Text(animals.id)) {
//          ForEach(animals) { animal in
//            NavigationLink(destination: AnimalDetailsView(animal: animal)) {
//              AnimalRow(animal: animal)
//            }
//          }
//        }
//      }
//      if !sectionedAnimals.isEmpty && viewModel.hasMoreAnimals {
//        ProgressView("Finding more animals...")
//          .padding()
//          .frame(maxWidth: .infinity)
//          .onAppear(perform: viewModel.fetchMoreAnimals)
//      }
      ForEach(animals) { animal in
        NavigationLink(destination: AnimalDetailsView(animal: animal)) {
          AnimalRow(animal: animal)
        }
      }
      if !animals.isEmpty && viewModel.hasMoreAnimals {
        ProgressView("Finding more animals...")
          .padding()
          .frame(maxWidth: .infinity)
          .onAppear(perform: viewModel.fetchMoreAnimals)
      }
    }
    .task(viewModel.fetchAnimals)
    .listStyle(.plain)
    .navigationTitle("Animals near you")
    .refreshable {
      viewModel.refresh()
    }
    .overlay {
      if viewModel.isLoading {
        ProgressView("Finding Animals near you...")
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          settingsIsPresented.toggle()
        } label: {
          Label("Settings", systemImage: "gearshape")
        }
        .sheet(isPresented: $settingsIsPresented) {
          PreferencesView()
        }
      }
    }
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AnimalsNearYouView(
        viewModel: AnimalsNearYouViewModel(
          isLoading: false,
          animalFetcher: AnimalFetcherMock(),
          context: PersistenceController.preview.container.viewContext
        )
      )
    }
    .environmentObject(LocationManager())
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )

    NavigationView {
      AnimalsNearYouView(
        viewModel: AnimalsNearYouViewModel(
          isLoading: false,
          animalFetcher: AnimalFetcherMock(),
          context: PersistenceController.preview.container.viewContext
        )
      )
    }
    .preferredColorScheme(.dark)
    .environmentObject(LocationManager())
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
  }
}
