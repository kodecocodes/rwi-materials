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
  var body: some View {
    Text("TODO: Animal Header View")
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
    .position(
      x: zoomed ? geometry.frame(in: .local).midX : 50,
      y: zoomed ? geometry.frame(in: .global).midX : 50
    )
    .scaleEffect((zoomed ? 5 : 3) / 3)
    .shadow(radius: zoomed ? 10 : 1)
    .animation(.spring(), value: zoomed)
  }
}

struct HeaderTitle: View {
  var body: some View {
    Text("TODO: Header Title")
  }
}

struct HeaderTitle_Previews: PreviewProvider {
  static var previews: some View {
    HeaderTitle()
  }
}

struct AnimalHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalHeaderView()
  }
}
