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

struct AnimalHeaderView: View {
  let animal: Animal
  
  var body: some View {
    VStack {
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
      .aspectRatio(1, contentMode: .fit)
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
    }
  }
}

extension View {
  @ViewBuilder
  func `if`<Transform: View>(_ condition: Bool, modify: (Self) -> Transform) -> some View {
    if condition {
      modify(self)
    } else {
      self
    }
  }
}

struct AnimalHeaderView2: View {

  #if DEBUG
  let animal: Animal
  #else
  let animal: AnimalEntity
  #endif
  
  @Binding var zoomed: Bool
  let geometry: GeometryProxy

  var body: some View {

    if zoomed {
      LazyVStack {
        AnimalImage(animalPicture: animal.picture, zoomed: $zoomed, geometry: geometry)
        HeaderTitle(animal: animal, zoomed: $zoomed, geometry: geometry)
      }
    }
    else {
      LazyHStack {
        AnimalImage(animalPicture: animal.picture, zoomed: $zoomed, geometry: geometry)
        HeaderTitle(animal: animal, zoomed: $zoomed, geometry: geometry)
      }
    }

  }
}

struct AnimalImage : View {

  let animalPicture: URL?
  @Binding var zoomed: Bool
  let geometry: GeometryProxy

  var body: some View {

    AsyncImage(url: animalPicture) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
    } placeholder: {
      Image("rw-logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay {
          if animalPicture != nil {
            ProgressView()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(.gray.opacity(0.4))
          }
        }
    }
    .clipShape(
      RoundedRectangle(cornerRadius: zoomed ? 0 : 300)
    )
    .frame(width: zoomed ? geometry.frame(in: .local).width  : 100,
           height: zoomed ? geometry.frame(in: .global).midX : 100)
    .position(
      x: zoomed ? geometry.frame(in: .local).midX : 50,
      y: zoomed ? geometry.frame(in: .global).midX : 50
    )
    .scaleEffect((zoomed ? 5 : 3) / 3)
    .shadow(radius: zoomed ? 10 : 1)
    .animation(.spring(), value: zoomed)
//        .onTapGesture { zoomed.toggle() }

  }

}

struct HeaderTitle : View {

  @Binding var zoomed: Bool
  var geometry: GeometryProxy
  let animalName: String?
  let animalType: String?

  #if DEBUG
  let animal: Animal

  init(animal: Animal, zoomed: Binding<Bool>, geometry: GeometryProxy) {
    self.animal = animal
    self.animalType = animal.type
    self.animalName = animal.name
    self._zoomed = zoomed
    self.geometry = geometry
  }

  #else
  let animal: AnimalEntity

  init(animal: AnimalEntity, zoomed: Binding<Bool>, geometry: GeometryProxy) {
    self.animal = animal
    self.animalType = animal.type
    self.animalName = animal.name
    self._zoomed = zoomed
    self.geometry = geometry
  }
  #endif

  var body: some View {

    VStack(alignment: .leading) {

      Text(animalName ?? "Default Name")
        .font(.largeTitle)
        .frame(maxWidth: .infinity, alignment: zoomed ? .center : .leading)
      Text("\(animal.breed) \(animalType ?? "")")
        .font(.title3)
        .frame(maxWidth: .infinity, alignment: zoomed ? .center : .leading)
    }
    .position(
      x: zoomed ? geometry.frame(in: .global).midX : 100, //geometry.frame(in: .global).midX : 100,
      y: zoomed ? geometry.frame(in: .local).midY /*+ geometry.frame(in: .global).midX*/ : 50
    )
//    .frame(width: zoomed ? geometry.frame(in: .local).width  : 100,
//           height: zoomed ? geometry.frame(in: .local).midX : 100)
//    .frame(maxWidth: .infinity)
    .animation(.spring(), value: zoomed)
  }

}

#if DEBUG
struct HeaderTitle_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geometry in
      HeaderTitle(animal: Animal.mock[0], zoomed: .constant(false), geometry: geometry)
    }
    .previewLayout(.sizeThatFits)
  }
}

struct AnimalHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalHeaderView(animal: Animal.mock[0])
      .previewLayout(.sizeThatFits)
  }
}
#else
struct HeaderTitle_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      if let animalEntity = CoreDataHelper.getTestAnimal() {

        Group {

          GeometryReader { geometry in
            HeaderTitle(animal: animalEntity, zoomed: .constant(true), geometry: geometry)
          }
          .frame(width: 200, height: 100)

          GeometryReader { geometry in
            HeaderTitle(animal: animalEntity, zoomed: .constant(false), geometry: geometry)
          }
          .frame(width: 200, height: 100)

        }

      } else {
        NavigationView {
          Text("No available test animal in database")
        }
      }
    }
    .previewLayout(.sizeThatFits)
  }
}

struct AnimalHeaderView_Previews: PreviewProvider {
  static var previews: some View {

    Group {
      if let animalEntity = CoreDataHelper.getTestAnimal() {
        Group {
          GeometryReader { geometry in
            AnimalHeaderView2(animal: animalEntity, zoomed: .constant(true), geometry: geometry)

          }
          .frame(width: 500, height: 700)

          GeometryReader { geometry in
            AnimalHeaderView2(animal: animalEntity, zoomed: .constant(false), geometry: geometry)

          }
          .frame(width: 500, height: 100)
        }


      } else {
        NavigationView {
          Text("No available test animal in database")
        }
      }
    }
    .previewLayout(.sizeThatFits)
  }
}


#endif

