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
import CoreLocationUI

struct PreferencesView: View {
  @EnvironmentObject var locationManager: LocationManager

  let locationDeniedText = """
  PetSave does not have access to your location.
  To enable acess, open Settings > Location > Location Services and allow location while using the app.
  """

  let locationReason = """
  PetSave can use your current location to find animals near you.
  If you don't live in the US, you can turn this feature off and use a mocked location.
  """

  var body: some View {
    NavigationView {
      List {
        Section {
          VStack {
            Toggle("Toggle real location", isOn: $locationManager.useUserLocation)
              .disabled(locationManager.locationIsDisabled)

            if locationManager.openInSettings {
              VStack(spacing: 16) {
                Text(locationDeniedText)
                  .multilineTextAlignment(.center)
                Button("Open Location Settings", action: openLocationSettings)
                  .font(.body.bold())
              }
            }

            if locationManager.shouldRequestForLocation {
              LocationButton(
                .currentLocation,
                action: locationManager.startUpdatingLocation
              )
              .cornerRadius(15)
              .padding()
              .symbolVariant(.fill)
              .foregroundColor(.white)
            }
          }
        } header: {
          Text("Location")
        } footer: {
          Text(locationReason)
        }
      }
      .onAppear(perform: locationManager.updateAuthorizationStatus)
      .navigationTitle("Preferences")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  func openLocationSettings() {
    guard let bundleId = Bundle.main.bundleIdentifier,
      let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") else { return }
    UIApplication.shared.open(url)
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    PreferencesView()
      .environmentObject(LocationManager())
  }
}
