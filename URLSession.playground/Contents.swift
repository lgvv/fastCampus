import UIKit

var urlString = "https://itunes.apple.com/search?media=music&entity=musicVideo&term=Gdragon"
let url = URL(string: urlString)

url?.absoluteString // 실제의 주소 - urlString과 같은값
url?.scheme // 프로토콜
url?.host // 제일 중요한주소
url?.path // host다음의 패스
url?.query // 검색어와 같은 질의문(조건)
url?.baseURL //

let baseURL = URL(string: "https://itunes.apple.com")
let relativeURL = URL(string:"search?media=music&entity=musicVideo&term=Gdragon", relativeTo: baseURL)

relativeURL?.absoluteURL
relativeURL?.scheme
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL

// URLComponents
var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
let mediaQuery = URLQueryItem(name: "media", value: "music")
let entityQuery = URLQueryItem(name: "entity", value: "song")
let termQuery = URLQueryItem(name: "term", value: "지드래곤") // 한글로 쳐도 서버가 이해할 수 있게 인코딩해준다.

urlComponents.queryItems?.append(mediaQuery)
urlComponents.queryItems?.append(entityQuery)
urlComponents.queryItems?.append(termQuery)

urlComponents.url
urlComponents.string
urlComponents.queryItems

// 1. URLSessionConfiguration
// 2. URLSession
// 3. URLSessionTask 를 이용해서 서바와 네트워킹

// URLSessionTask

// -dataTask
// -uploadTask
// -downloadTask

let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)

let requestURL = urlComponents.url!

struct Response: Codable {
    let resultCount: Int
    let tracks: [Track]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case tracks = "results"
    }
}

struct Track: Codable {
    let title: String
    let artistName: String
    let thumbnailPath: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artistName
        case thumbnailPath = "artworkUrl100"
    }
}


let dataTask = session.dataTask(with: requestURL) { (data, respnse, error) in
    guard error == nil else { return } // 에러가 있으면 그냥 끝내기
    
    guard let statusCode = (respnse as? HTTPURLResponse)?.statusCode else { return } // 위키피디아에 들억가면 에러코드에 대한 설명이 나온다.
    let successRange = 200..<300 // 200에서 300전까지의 숫자
    
    guard successRange.contains(statusCode) else {
        // handle response error
        return
    }
    
    guard let resultData = data else { return }
    let resultString = String(data: resultData, encoding: .utf8)
    //print("-->result\(resultData)")
    
    // 목표 : 트랙리스트 오브젝트로 가져오기
    
    // 하고 싶은 작업 목록
    // - Data -> Track 목록으로 가져오고 싶다 [Track]
    // - Track 오브젝트를 만들어야 겠다
    // - Data에서 struct로 파싱하고 싶다 > Codable 이용해서 만들자
    //  - JSON 파일, 데이터 > 오브젝트 (Codable 이용하겠다)
    //  - Response, Track 이렇게 두개 만들어야 겠다.
    
    // 해야할 일
    // - Response, Track struct
    // - struct의 프로퍼티 이름과 실제 데이터의 키와 맞추기 (Codable 디코딩 하기 위해서)
    // - 파싱하기 (Decoding)
    // - 트랙리스트 가져오기
    
    
    // 파싱 및 트랙 가져오기
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response.self, from: resultData) // try는 이 작업이 항상 성공한다는 보장이 없다는 말. 실패시 catch로 이동 -> 리절트 데이터를 리스폰스.self로 디코딩한다.
        let tracks = response.tracks
        
        print("--> tracks : \(tracks.count)")
    } catch let error {
        print("--> error : \(error.localizedDescription)")
    }
    
}

dataTask.resume()

