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
  @EnvironmentObject var locationManager: LocationManager
  @ObservedObject var viewModel: AnimalsNearYouViewModel
  @State var settingsIsPresented = false

  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \AnimalEntity.timestamp, ascending: true)
    ],
    animation: .default
  )
  var animals: FetchedResults<AnimalEntity>

  var showLocationIndicator: Bool {
    !locationManager.locationIsDisabled && locationManager.useUserLocation
  }

  var body: some View {
    List {
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
    .task {
      await viewModel.fetchAnimals()
    }
    .onAppear(perform: locationManager.updateAuthorizationStatus)
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
        Button(action: presentSettings) {
          Label("Settings", systemImage: "gearshape")
        }
        .sheet(isPresented: $settingsIsPresented) {
          PreferencesView()
        }
      }

      ToolbarItem(placement: .navigationBarLeading) {
        if showLocationIndicator {
          Menu {
            Button {
              locationManager.useUserLocation.toggle()
            } label: {
              Label("Disable real location", systemImage: "location.slash.fill")
            }
          } label: {
            Label("User location is enabled", systemImage: "location.fill")
          }
        }
      }
    }
  }

  func presentSettings() {
    settingsIsPresented.toggle()
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        AnimalsNearYouView(
          viewModel: AnimalsNearYouViewModel(
            isLoading: false,
            animalFetcher: AnimalFetcherMock(),
            animalsRepository: AnimalsRepositoryMock(),
            locationManager: mockLocationAuthorization
          )
        )
      }

      NavigationView {
        AnimalsNearYouView(
          viewModel: AnimalsNearYouViewModel(
            isLoading: false,
            animalFetcher: AnimalFetcherMock(),
            animalsRepository: AnimalsRepositoryMock(),
            locationManager: mockLocationAuthorization
          )
        )
      }
      .preferredColorScheme(.dark)
    }
    .environmentObject(mockLocationAuthorization)
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
  }
}

private extension PreviewProvider {
  static var mockLocationAuthorization: LocationManager {
    let locationManager = LocationManager()
    locationManager.useUserLocation = true
    locationManager.authorizationStatus = .authorizedWhenInUse
    return locationManager
  }
}
