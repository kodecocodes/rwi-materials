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

struct AnimalHeaderView: View {
  let animal: AnimalEntity

  @Binding var zoomed: Bool
  @Binding var favorited: Bool
  let geometry: GeometryProxy

  var body: some View {
    if zoomed {
      LazyVStack {
        AnimalImage(animalPicture: animal.picture, zoomed: $zoomed, geometry: geometry)
        HeaderTitle(animal: animal, zoomed: $zoomed, geometry: geometry)
      }
    } else {
      HStack {
        AnimalImage(animalPicture: animal.picture, zoomed: $zoomed, geometry: geometry)
        HeaderTitle(animal: animal, zoomed: $zoomed, geometry: geometry)
        Image(systemName: favorited ? "heart.fill" : "heart")
          .font(.system(size: 50))
          .foregroundColor( favorited ? Color(.systemRed) : Color(.black))
          .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50)
          .animation(favorited ? .interpolatingSpring(
            mass: 5,
            stiffness: 3.0,
            damping: 1.0,
            initialVelocity: 1) : .default, value: $favorited.wrappedValue)
          .onTapGesture {
            $favorited.wrappedValue.toggle()
          }
        Spacer(minLength: 25)
      }
    }
  }
}

struct AnimalImage: View {
  let animalPicture: URL?
  @Binding var zoomed: Bool
  let geometry: GeometryProxy

  var body: some View {
    AsyncImage(url: animalPicture) { image in
      image
        .resizable()
        .aspectRatio(zoomed ? nil : 1, contentMode: zoomed ? .fit : .fill)
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
    .frame(
      width: zoomed ? geometry.frame(in: .local).width : 100,
      height: zoomed ? geometry.frame(in: .global).midX : 100
    )
    .offset(
      x: zoomed ? 0 : 0,
      y: zoomed ? geometry.frame(in: .local).midY / 3 : 0
    )
    .scaleEffect((zoomed ? 5 : 3) / 3)
    .shadow(radius: zoomed ? 10 : 1)
    .animation(.spring(), value: zoomed)
  }
}

struct HeaderTitle: View {
  @Binding var zoomed: Bool
  var geometry: GeometryProxy
  let animalName: String?
  let animalType: String?

  let animal: AnimalEntity

  init(animal: AnimalEntity, zoomed: Binding<Bool>, geometry: GeometryProxy) {
    self.animal = animal
    self.animalType = animal.type
    self.animalName = animal.name
    self._zoomed = zoomed
    self.geometry = geometry
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(animalName ?? "Default Name")
        .font(.largeTitle)
        .frame(maxWidth: .infinity, alignment: zoomed ? .center : .leading)
        .accessibility(label: Text("The pet's name."))
      Text("\(animal.breed) \(animalType ?? "")")
        .font(.title3)
        .frame(maxWidth: .infinity, alignment: zoomed ? .center : .leading)
        .accessibility(label: Text("The pet's breed: " + animal.breed))
    }
    .offset(
      x: zoomed ? 0 : 0,
      y: zoomed ? geometry.frame(in: .local).midY : 0
    )

    .animation(.spring(), value: zoomed)
  }
}

struct HeaderTitle_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      Group {
        GeometryReader { geometry in
          HeaderTitle(animal: animal, zoomed: .constant(true), geometry: geometry)
        }
        .frame(width: 200, height: 150)

        GeometryReader { geometry in
          HeaderTitle(animal: animal, zoomed: .constant(false), geometry: geometry)
        }
        .frame(width: 200, height: 100)
      }
      .previewLayout(.sizeThatFits)
    }
  }
}

struct AnimalHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      Group {
        GeometryReader { geometry in
          AnimalHeaderView(animal: animal, zoomed: .constant(true), favorited: .constant(false), geometry: geometry)
        }
        .frame(width: 500, height: 700)

        GeometryReader { geometry in
          AnimalHeaderView(animal: animal, zoomed: .constant(false), favorited: .constant(true), geometry: geometry)
        }
        .frame(width: 500, height: 100)

        GeometryReader { geometry in
          AnimalHeaderView(animal: animal, zoomed: .constant(false), favorited: .constant(false), geometry: geometry)
        }
        .frame(width: 500, height: 100)
      }
      .previewLayout(.sizeThatFits)
    }
  }
}
