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

import CoreLocation
import SwiftUI

final class LocationManager: NSObject, ObservableObject {
  @Published var authorizationStatus: CLAuthorizationStatus

  typealias LocationContinuation = CheckedContinuation<CLLocation, Error>
  private var continuation: LocationContinuation?

  private lazy var cllLocationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    return manager
  }()

  init(authorizationStatus: CLAuthorizationStatus = .notDetermined) {
    self.authorizationStatus = authorizationStatus
  }

  func requestWhenInUseAuthorization() {
    cllLocationManager.requestWhenInUseAuthorization()
  }

  func updateAuthorizationStatus() {
    authorizationStatus = cllLocationManager.authorizationStatus
    switch authorizationStatus {
    case .notDetermined:
      break
    case .authorizedAlways, .authorizedWhenInUse:
      cllLocationManager.startUpdatingLocation()
    default:
      continuation?.resume(
        throwing: NSError(domain: "The app isn't authorized to use location data", code: -1)
      )
      continuation = nil
    }
  }

  func shareLocation() async throws -> CLLocation {
    return try await withCheckedThrowingContinuation { [weak self] continuation in
      self?.continuation = continuation
      self?.cllLocationManager.startUpdatingLocation()
    }
  }
}

// MARK: - Location status
extension LocationManager {
  var locationIsDisabled: Bool {
    authorizationStatus == .denied ||
      authorizationStatus == .notDetermined ||
      authorizationStatus == .restricted
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    updateAuthorizationStatus()
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.first else { return }
    continuation?.resume(returning: location)
    continuation = nil
    cllLocationManager.stopUpdatingLocation()
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    continuation?.resume(throwing: error)
    continuation = nil
    cllLocationManager.stopUpdatingLocation()
  }
}
