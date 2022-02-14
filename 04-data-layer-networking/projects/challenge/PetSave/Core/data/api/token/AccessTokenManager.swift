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

import Foundation

protocol AccessTokenManagerProtocol {
  func isTokenValid() -> Bool
  func fetchToken() -> String
  func refreshWith(apiToken: APIToken) throws
}

class AccessTokenManager {
  private let userDefaults: UserDefaults
  private var accessToken: String?
  private var expiresAt = Date()

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
}

// MARK: - AccessTokenManagerProtocol
extension AccessTokenManager: AccessTokenManagerProtocol {
  func isTokenValid() -> Bool {
    accessToken = getToken()
    expiresAt = getExpirationDate()
    return accessToken != nil && expiresAt.compare(Date()) == .orderedDescending
  }

  func fetchToken() -> String {
    guard let token = accessToken else {
      return ""
    }
    return token
  }

  func refreshWith(apiToken: APIToken) throws {
    let expiresAt = apiToken.expiresAt
    let token = apiToken.bearerAccessToken

    save(token: apiToken)
    self.expiresAt = expiresAt
    self.accessToken = token
  }
}

// MARK: - Token Expiration
private extension AccessTokenManager {
  func save(token: APIToken) {
    userDefaults.set(token.expiresAt.timeIntervalSince1970, forKey: AppUserDefaultsKeys.expiresAt)
    userDefaults.set(token.bearerAccessToken, forKey: AppUserDefaultsKeys.bearerAccessToken)
  }

  func getExpirationDate() -> Date {
    Date(timeIntervalSince1970: userDefaults.double(forKey: AppUserDefaultsKeys.expiresAt))
  }

  func getToken() -> String? {
    userDefaults.string(forKey: AppUserDefaultsKeys.bearerAccessToken)
  }
}
