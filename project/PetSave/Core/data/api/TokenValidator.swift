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

import Foundation

protocol TokenValidatorProtocol {
  func validateToken() async throws -> String
}

actor TokenValidator {
  private let userDefaults: UserDefaults
  private let authFetcher: AuthTokenFetcher
  private let keychainManager: KeychainManagerProtocol
  private let server = APIConstants.host
  private var accesstoken: String?
  private var expiresAt = Date()

  init(userDefaults: UserDefaults, authFetcher: AuthTokenFetcher, keychainManager: KeychainManagerProtocol) {
    self.userDefaults = userDefaults
    self.authFetcher = authFetcher
    self.keychainManager = keychainManager
  }
}

// MARK: - TokenValidatorProtocol
extension TokenValidator: TokenValidatorProtocol {
  func validateToken() async throws -> String {
    if let token = accesstoken, expiresAt.compare(Date()) == .orderedDescending {
      // Token and expiresAt are cached in-memory.
      return token
    }

    // Token and expiresAt are not cached in-memory.
    // Tries to fetch token from keychain and expires at from UserDefaults.
    if let keychainToken = await findToken(),
      let expiresAt = getExpiresAt(), expiresAt.compare(Date()) == .orderedDescending {
      self.accesstoken = keychainToken
      self.expiresAt = expiresAt
      return keychainToken
    }

    // Token and expiresAt are not cached nor on Keychain/UserDefaults.
    // Must fetch from API
    let apiToken = try await fetchToken()
    try await refreshWith(apiToken: apiToken)
    return apiToken.bearerAccessToken
  }
}

// MARK: - Private methods
private extension TokenValidator {
  func fetchToken() async throws -> APIToken {
    return try await authFetcher.fetchToken()
  }

  func refreshWith(apiToken: APIToken) async throws {
    let expiresAt = apiToken.expiresAt
    let accesstoken = apiToken.bearerAccessToken

    if await findToken() != nil {
      try await update(token: accesstoken)
    } else {
      try await save(token: accesstoken)
    }

    save(expiresAt: expiresAt)
    self.expiresAt = expiresAt
    self.accesstoken = accesstoken
  }
}

// MARK: - Token Expiration
private extension TokenValidator {
  func save(expiresAt: Date) {
    userDefaults.set(expiresAt.timeIntervalSince1970, forKey: "expiresAt")
  }

  func getExpiresAt() -> Date? {
    Date(timeIntervalSince1970: userDefaults.double(forKey: "expiresAt"))
  }
}

// MARK: - Keychain
private extension TokenValidator {
  func findToken() async -> String? {
    return keychainManager.findKey(server: server, keyClass: kSecClassInternetPassword)
  }

  func save(token: String) async throws {
    try keychainManager.save(key: token, server: server, keyClass: kSecClassInternetPassword)
  }

  func update(token: String) async throws {
    guard let tokenData = token.data(using: .utf8) else { throw KeychainError.failedToConvertToData }
    let attributes = [kSecValueData: tokenData] as CFDictionary
    return try keychainManager.updateKey(attributes: attributes, server: server, keyClass: kSecClassInternetPassword)
  }
}
