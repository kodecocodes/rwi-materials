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

protocol RequestManagerProtocol {
  var apiManager: APIManagerProtocol { get }
  var parser: DataParserProtocol { get }
  var accessTokenManager: AccessTokenManagerProtocol { get }
  func request<T: Decodable>(with router: RouterProtocol) async throws -> T
  func requestAccessToken() async throws -> String
}

extension RequestManagerProtocol {
  
  var parser: DataParserProtocol {
    return DataParser()
  }
  
  func request<T: Decodable>(with router: RouterProtocol) async throws -> T {
    let authToken = try await requestAccessToken()
    let data = try await apiManager.request(with: router, authToken: authToken)
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
}

class RequestManager: RequestManagerProtocol {
  let apiManager: APIManagerProtocol
  let accessTokenManager: AccessTokenManagerProtocol

  init(
    apiManager: APIManagerProtocol = APIManager(),
    accessToken: AccessTokenManagerProtocol = AccessTokenManager(
      userDefaults: .standard,
      keychainManager: KeychainManager())
  ) {
    self.apiManager = apiManager
    self.accessTokenManager = accessToken
  }
  
  func requestAccessToken() async throws -> String {
    if accessTokenManager.isTokenValid() {
      return accessTokenManager.fetchToken()
    }
    
    let data = try await apiManager.request(with: AuthTokenRouter.auth, authToken: "")
    let token: APIToken = try parser.parse(data: data)
    try accessTokenManager.refreshWith(apiToken: token)
    return token.bearerAccessToken
  }
}
