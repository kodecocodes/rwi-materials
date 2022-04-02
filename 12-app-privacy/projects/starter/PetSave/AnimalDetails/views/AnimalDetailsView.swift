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

struct AnimalDetailsView: View {
  @State var zoomed = false
  @State var favorited = false

  let animal: AnimalEntity

  var animalDescription: String? {
    animal.desc
  }

  var animalName: String? {
    animal.name
  }

  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        ZStack(alignment: .leading) {
          LazyVStack(alignment: .leading) {
            AnimalHeaderView(
              animal: animal,
              zoomed: $zoomed,
              favorited: $favorited,
              geometry: geometry)
              .onTapGesture { zoomed.toggle() }
            Divider()
              .blur(radius: zoomed ? 20 : 0)
            PetRankingView(animal: animal)
              .padding()
              .blur(radius: zoomed ? 20 : 0)
            AnimalDetailRow(animal: animal)
              .blur(radius: zoomed ? 20 : 0)
            Divider()
              .blur(radius: zoomed ? 20 : 0)
            VStack(alignment: .leading, spacing: 24) {
              if let description = animalDescription {
                VStack(alignment: .leading) {
                  Text("Details")
                    .font(.headline)
                  Text(description)
                    .accessibility(label: Text("Details about this pet: " + description))
                }
              }
              AnimalContactsView(animal: animal)
              Divider()
                .blur(radius: zoomed ? 20 : 0)
              AnimalLocationView(animal: animal)
            }
            .blur(radius: zoomed ? 20 : 0)
            .padding(.horizontal)
            .padding(.bottom)
          }
          .animation(.spring(), value: zoomed)
        }
      }
    }
    .navigationTitle(animalName ?? "")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct AnimalsView_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      NavigationView {
        AnimalDetailsView(animal: animal)
          .previewLayout(.sizeThatFits)
      }
      .previewLayout(.sizeThatFits)
      .previewDisplayName("iPhone SE (2nd generation)")

      NavigationView {
        AnimalDetailsView(animal: animal)
      }
      .previewDevice("iPhone 12 Pro")
      .previewDisplayName("iPhone 12 Pro")
    }
  }
}
