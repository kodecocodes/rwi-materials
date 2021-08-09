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

//Chapter 10: Animation here while data is loading
//Chapter 10: Animate image of pet to full screen
//Chapter 10: Custom control for ranking

struct AnimalDetailsView: View {
  @State var zoomed = false

  let animal: AnimalEntity

  var animalDescription: String? {
    animal.description
  }

  var animalName: String? {
    animal.name
  }
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        ZStack(alignment: .leading) {

          LazyVStack(alignment: .leading) {
            AnimalHeaderView2(animal: animal, zoomed: $zoomed, geometry: geometry)
              .onTapGesture { zoomed.toggle() }
            AnimalDetailRow(animal: animal)
              .blur(radius: zoomed ? 20 : 0)
            VStack(alignment: .leading, spacing: 24) {
              if let description = animalDescription {
                VStack(alignment: .leading) {
                  Text("Details")
                    .font(.title2)
                  Text(description)
                }
              }
              AnimalContactsView(animal: animal)
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
    let animal = CoreDataHelper.getTestAnimal()!
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
