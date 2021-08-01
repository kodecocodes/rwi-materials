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

import UIKit

protocol PetFinderAPIRouterProtocol {
  var path: String { get }
  var requestType: RequestType { get }
  var headers: [String : String] { get }
  var params: [String : Any] { get }
}

extension PetFinderAPIRouterProtocol {
  var baseURL: String {
    APIConstants.baseURLString
  }
  
  var params: [String : Any] {
    [:]
  }
  
  var headers: [String : String] {
    [
      "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5VEZ3R0JjOG12NUxTa01sNHd2a2pDZ1FScXNTMzJOVHk0MllJVUtZcnVSODAwbHBMcCIsImp0aSI6ImMzMGU0MDgxZDk0YjhmMDNlNDEyNTJkMGQ1NTE1NzM3ODI3ZWJhYjFkNGUzYmI1NmM1Y2NiZDNmZDNhZWE3YmEzZmE2YTk2ZWJhMWZiNTE2IiwiaWF0IjoxNjI3Nzk0NzU1LCJuYmYiOjE2Mjc3OTQ3NTUsImV4cCI6MTYyNzc5ODM1NSwic3ViIjoiIiwic2NvcGVzIjpbXX0.dELLJk4ue26TRhSZEmBSthaCxUVsuVrAMALyY0yhJDdwo2r7vR6oGk8Rw7VBTULXEQPauO1czG0vGO9HioC0nCEW_xQsV5DCZ_GWSGO5X820ADh-WQ9lPZyrSdo7RoH31Ao1wYFDSCSr41_F9t6Dopy7u9lF4HoxCwTnbXHcJI4e6eNGd1kaopjVOXitIsHFyzFQ0_y7LyMCvwbFX9Yy9SswatwylqwfrxoxVkCOwImqTtA3PWs5CnZ4-oCWYNsI2nzEZ0UBNuF6AHTPAQZ9_FoVipWwrJ9HAexwvgXW5Gs8aELhfGI79W810hcxz6Vg2NDpQJVlqAdyvjSnyaPYbQ"
    ]
  }
  
  func urlRequest() throws -> URLRequest {
    let requestURL = URL(string: baseURL + path)!
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = requestType.rawValue
    if !headers.isEmpty {
      urlRequest.allHTTPHeaderFields = headers
    }
    if !params.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
    }
    printURLRequest(urlRequest)
    return urlRequest
  }
  
  private func printURLRequest(_ urlRequest: URLRequest) {
    print()
    print("↗️↗️↗️ Outgoing Request ↗️↗️↗️")
    print("URL: \(urlRequest)")
    print()
    
    if let headers = urlRequest.allHTTPHeaderFields {
      print("Headers:")
      print(headers)
      print()
    }
    
    if let httpBody = urlRequest.httpBody {
      print("Body:")
      print(httpBody)
      print()
    }
  }
}

enum RequestType: String {
  case GET = "GET"
  case POST = "POST"
}
