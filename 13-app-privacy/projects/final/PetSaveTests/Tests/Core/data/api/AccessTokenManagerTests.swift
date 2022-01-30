///// Copyright (c) 2022 Razeware LLC
///// 
///// Permission is hereby granted, free of charge, to any person obtaining a copy
///// of this software and associated documentation files (the "Software"), to deal
///// in the Software without restriction, including without limitation the rights
///// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
///// copies of the Software, and to permit persons to whom the Software is
///// furnished to do so, subject to the following conditions:
///// 
///// The above copyright notice and this permission notice shall be included in
///// all copies or substantial portions of the Software.
///// 
///// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
///// distribute, sublicense, create a derivative work, and/or sell copies of the
///// Software in any work that is designed, intended, or marketed for pedagogical or
///// instructional purposes related to programming, coding, application development,
///// or information technology.  Permission for such use, copying, modification,
///// merger, publication, distribution, sublicensing, creation of derivative works,
///// or sale is expressly withheld.
///// 
///// This project and source code may use libraries or frameworks that are
///// released under various Open-Source licenses. Use of those libraries and
///// frameworks are governed by their own individual licenses.
/////
///// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
///// THE SOFTWARE.

import XCTest
@testable import PetSave

class AccessTokenManagerTests: XCTestCase {
  var accessTokenManager: AccessTokenManagerProtocol?
  var requestManager: RequestManagerMock?

  override func setUp() {
    super.setUp()
    guard let userDefaults = UserDefaults(suiteName: #file) else { return }
    userDefaults.removePersistentDomain(forName: #file)
    accessTokenManager = AccessTokenManager(userDefaults: userDefaults)
    guard let accessTokenManager = accessTokenManager else { return }
    requestManager = RequestManagerMock(apiManager: APIManagerMock(), accessTokenManager: accessTokenManager)
  }

  func testRequestToken() async throws {
    guard let token = try await requestManager?.requestAccessToken() else { return }
    XCTAssertFalse(token.isEmpty)
  }

  func testCachedToken() async throws {
    let token = try await requestManager?.requestAccessToken()
    let sameToken = accessTokenManager?.fetchToken()
    XCTAssertEqual(token, sameToken)
  }

  func testRequestNewToken() async throws {
    guard let token = try await requestManager?.requestAccessToken() else { return }
    guard let accessTokenManager = accessTokenManager else { return }
    XCTAssertTrue(accessTokenManager.isTokenValid())
    let exp = expectation(description: "Test token validity after 10 seconds")
    let result = XCTWaiter.wait(for: [exp], timeout: 10.0)
    if result == XCTWaiter.Result.timedOut {
      XCTAssertFalse(accessTokenManager.isTokenValid())
      let newToken = try await requestManager?.requestAccessToken()
      XCTAssertTrue(accessTokenManager.isTokenValid())
      XCTAssertNotEqual(token, newToken)
    } else {
      XCTFail("Test failed.")
    }
  }

  func testRefreshToken() async throws {
    guard let token = try await requestManager?.requestAccessToken() else { return }
    let randomToken = AccessTokenTestHelper.randomAPIToken()
    guard let accessTokenManager = accessTokenManager else { return }
    try accessTokenManager.refreshWith(apiToken: randomToken)
    XCTAssertNotEqual(token, accessTokenManager.fetchToken())
    XCTAssertEqual(randomToken.bearerAccessToken, accessTokenManager.fetchToken())
  }
}
