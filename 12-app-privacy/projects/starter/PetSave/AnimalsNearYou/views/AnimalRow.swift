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

struct AnimalRow: View {
  let animal: AnimalEntity

  var animalName: String

  var animalType: String

  var animalDescription: String

  var animalBreedAndType: String {
    "\(animal.breed) \(animalType)"
  }

  init(animal: AnimalEntity) {
    self.animal = animal
    animalName = animal.name ?? ""
    animalType = animal.type ?? ""
    animalDescription = animal.desc ?? ""
  }

  var body: some View {
    HStack {
      AsyncImage(url: animal.picture) { image in
        image
          .resizable()
          .accessibilityLabel("Image of Pet")
      } placeholder: {
        Image("rw-logo")
          .resizable()
          .accessibilityLabel("Placeholder Logo")
          .overlay {
            if animal.picture != nil {
              ProgressView()
                .accessibilityLabel("Image loading indicator")
                .accessibilityHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.4))
            }
          }
      }
      .aspectRatio(contentMode: .fit)
      .frame(width: 112, height: 112)
      .cornerRadius(8)

      VStack(alignment: .leading) {
        Text(animalName)
          .multilineTextAlignment(.center)
          .font(Font.custom("sheep_sans", size: 18, relativeTo: .title3))
          .accessibilityLabel(animalName)
        Text(animalBreedAndType)
          .font(Font.custom("sheep_sans", size: 15, relativeTo: .callout))
          .accessibilityLabel(animalBreedAndType)
          .accessibilityHidden(true)
        if let description = animal.desc {
          Text(description)
            .lineLimit(2)
            .font(.footnote)
            .accessibilityLabel(description)
            .accessibilityHidden(true)
        }

        HStack {
          Text(NSLocalizedString(animal.age.rawValue, comment: ""))
            .modifier(AnimalAttributesCard(color: animal.age.color))
            .accessibilityLabel(animal.age.rawValue)
            .accessibilityHidden(true)
          Text(NSLocalizedString(animal.gender.rawValue, comment: ""))
            .modifier(AnimalAttributesCard(color: .pink))
            .accessibilityLabel(animal.gender.rawValue)
        }
      }
      .lineLimit(1)
    }
    .accessibilityElement(children: .combine)
    .accessibilityCustomContent("Age", animal.age.rawValue, importance: .high)
    .accessibilityCustomContent("Breed", animal.breed)
    .accessibilityCustomContent("Type", animalType)
    .accessibilityCustomContent("Description", animalDescription)
  }
}

struct AnimalRow_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      AnimalRow(animal: animal)
        .previewLayout(.sizeThatFits)
    }
  }
}
