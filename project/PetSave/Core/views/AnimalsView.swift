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
import MapKit

//Chapter 10: Animation here while data is loading
//Chapter 10: Animate image of pet to full screen
//Chapter 10: Custom control for ranking

class LocationFetcher: ObservableObject {
  @Published var coordinates = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 37.3320003,
      longitude: -122.0307812
    ),
    span: MKCoordinateSpan(
      latitudeDelta: 0.01,
      longitudeDelta: 0.01
    )
  )
  
  private let geocoder = CLGeocoder()
  
  func search(by address: String) async {
    guard let placemarks = try? await geocoder.geocodeAddressString(address) else { return }
    if let location = placemarks.first?.location {
      coordinates.center.latitude = location.coordinate.latitude
      coordinates.center.longitude = location.coordinate.longitude
    }
  }
}

struct AnimalsView: View {
  let animal: Animal
  
  @StateObject var locationFetcher = LocationFetcher()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        AsyncImage(url: animal.picture) { image in
          image
            .resizable()
        } placeholder: {
          Image("rw-logo")
            .resizable()
            .overlay {
              if animal.picture != nil {
                ProgressView()
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(.gray.opacity(0.4))
              }
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .cornerRadius(8)
          
        VStack(alignment: .leading) {
          HStack {
            Text(animal.name)
              .font(.largeTitle)
            Spacer()
            Text(animal.type)
          }
          Text(animal.breed)
            .font(.title3)
        }
        .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            AnimalDetailCard(
              title: "Age",
              value: animal.age.rawValue,
              color: animal.age.color
            )

            AnimalDetailCard(
              title: "Gender",
              value: animal.gender.rawValue,
              color: .pink
            )

            AnimalDetailCard(
              title: "Size",
              value: animal.size.rawValue,
              color: .mint
            )
            
            if let coat = animal.coat {
              AnimalDetailCard(
                title: "Coat",
                value: coat.rawValue,
                color: .brown
              )
            }
          }
          .padding(.horizontal)
        }
        
        VStack(alignment: .leading, spacing: 24) {
          if let description = animal.description {
            VStack(alignment: .leading) {
              Text("Details")
                .font(.title2)
              Text(description)
            }
          }
          
          VStack(alignment: .leading) {
            VStack(alignment: .leading) {
              Text("Contact details")
                .font(.headline)
              Group {
                Text(animal.contact.email)
                Text(animal.contact.phone ?? "")
              }
              .textSelection(.enabled)
              
              HStack {
                if let phoneLink = animal.phoneLink {
                  Link(destination: phoneLink) {
                      VStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                          .imageScale(.large)
                          .foregroundColor(.green)
                        Text("call")
                          .font(.caption2)
                          .foregroundColor(.green)
                      }
                  }
                  .padding(.vertical)
                  .frame(width: 96)
                  .background(.green.opacity(0.1))
                  .cornerRadius(8)
                }
                  
                if let emailLink = animal.emailLink {
                  Link(destination: emailLink) {
                    VStack(spacing: 4) {
                      Image(systemName: "envelope.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                      Text("mail")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    }
                  }
                  .padding(.vertical)
                  .frame(width: 96)
                  .background(.blue.opacity(0.1))
                  .cornerRadius(8)
                }
              }
            }
            
            VStack(alignment: .leading, spacing: 4) {
              Text("Location")
                .font(.headline)
              Text(animal.address)
                .font(.subheadline)
                .textSelection(.enabled)
              
              Button(action: openAddressInMaps) {
                Map(coordinateRegion: $locationFetcher.coordinates, interactionModes: [])
                  
              }
              .buttonStyle(.plain)
              .frame(height: 200)
              .cornerRadius(16)
              .task {
                await locationFetcher.search(by: animal.address)
              }
            }
          }
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
    .navigationTitle(animal.name)
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func openAddressInMaps() {
    let placemark = MKPlacemark(coordinate: locationFetcher.coordinates.center)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.openInMaps(launchOptions: nil)
  }
}

struct AnimalsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AnimalsView(animal: Animal.mock[0])
    }
  }
}

struct AnimalDetailCard: View {
  let title: String
  let value: String
  let color: Color
  var body: some View {
    VStack {
      Text(title)
        .font(.subheadline)
      Text(value)
        .font(.headline)
    }
    .padding(.vertical)
    .frame(width: 96)
    .background(color.opacity(0.2))
    .foregroundColor(color)
    .cornerRadius(8)
  }
}
