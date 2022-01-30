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

struct SearchFilterView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var viewModel: SearchViewModel

  var body: some View {
    Form {
      Section {
        Picker("Age", selection: $viewModel.ageSelection) {
          ForEach(AnimalSearchAge.allCases, id: \.self) { age in
            Text(age.rawValue.capitalized)
          }
        }
        .onChange(of: viewModel.ageSelection) { _ in
          viewModel.search()
        }

        Picker("Type", selection: $viewModel.typeSelection) {
          ForEach(AnimalSearchType.allCases, id: \.self) { type in
            Text(type.rawValue.capitalized)
          }
        }
        .onChange(of: viewModel.typeSelection) { _ in
          viewModel.search()
        }
      } footer: {
        Text("You can mix both, age and type, to make a more accurate search.")
      }
      Button("Clear", role: .destructive, action: viewModel.clearFilters)
      Button("Done") {
        dismiss()
      }
    }
    .navigationBarTitle("Filters")
    .toolbar {
      ToolbarItem {
        Button {
          dismiss()
        } label: {
          Label("Close", systemImage: "xmark.circle.fill")
        }
      }
    }
  }
}

struct SearchFilterView_Previews: PreviewProvider {
  static var previews: some View {
    let context = PersistenceController.preview.container.viewContext
    NavigationView {
      SearchFilterView(
        viewModel: SearchViewModel(
          animalSearcher: AnimalSearcherMock(),
          animalStore: AnimalStoreService(context: context)
        )
      )
    }
  }
}
