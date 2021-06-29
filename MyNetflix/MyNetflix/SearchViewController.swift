//
//  SearchViewController.swift
//  MyNetflix
//
//  Created by Hamlit Jason on 2021/06/29.
//

import UIKit
import Kingfisher
import AVFoundation

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class ResultCell : UICollectionViewCell {
    @IBOutlet weak var movieThumbnail : UIImageView!
}

extension SearchViewController : UICollectionViewDataSource {
    // 몇개 넘어오니?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
        
    }
    // 어떻게 표현할거니?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.item]
        
        // imagepath(string) -> image : 이 작업은 직접 구현해도 좋으나 서드파티(외부) 라이브러리를 사용하는 연습도 할겸 외부 코드로 가져다 쓰겠다.
        // SPM(스위프트 패키지 매니저), Cocoa Pod, Carthago
        let url = URL(string: movie.thumbnailPath)! // 이미지가 url로 내려오는데 string타입을 받아서
        cell.movieThumbnail.kf.setImage(with: url) // 킹피셔를 이용해서 손쉽게 해결!
        
        //cell.backgroundColor = .red
        return cell
    }
    
    
}

extension SearchViewController : UICollectionViewDelegate {
    // 클릭했을 때 어떻게 할거야?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 무비아이템 가지고 playerVC에다가 무비를 전달 후 띄워주기
        
        let movie = movies[indexPath.item]
        let url = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: url)
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        
        vc.modalPresentationStyle = .fullScreen
        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: true, completion: nil)
        
        
    }
}

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    // 레이아웃은?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10/7
        return CGSize(width: width, height: height)
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder() // 포커싱을 놔줘라
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 키보드가 올라와 있을때, 내려가게 처리
        dismissKeyboard()
        // 검색어가 있는지
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else {
            // 서치바의 텍스트를 서치텀에 넣고, 서치텀의 내용이 비어있지 않으면 스무스하게 넘어가고 그렇지 않으면 리턴
            return
        }
        
        // 네트워킹을 통한 검색
        // - 목표: 서치텀을 가지고 네트워킹을 통해서 영화 검색
        // - 검색API 가 필요
        // - 결과를 받아올 모델 Movie, Respone
        // - 결과를 받아와서, CollectionView로 표현해주자
        
        SearchAPI.search(searchTerm) { movies in
            // - collectionView로 표현하기
            print("--> 몇개 넘어왔어?? \(movies.count), 첫번째꺼 제목: \(movies.first?.title)")
            DispatchQueue.main.async {
                self.movies = movies // 넘어온 무비를 변수 무비에 세팅해주고
                self.resultCollectionView.reloadData() // 컬렉션뷰 리로드
            }
        }
        
        print("--> 검색어: \(searchTerm)")
    }
}

class SearchAPI {
    static func search(_ term: String, completion: @escaping ([Movie]) -> Void) { // completion 클로저를 사용하기 위한 방법
        // 이스케이핑이 있으면 함수가 종료되고 나서 실행
        
        let session = URLSession(configuration: .default) // 1. 세션 만들기
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url! // 2. url 구성
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            guard error == nil,
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                // 에러가 없고, 상태코드에 응답에 대한 HTTPURLResponse에서 찾아 할당하고, 상태코드가 범위 안에 포함된다면 스무스하게 넘어가고
                // 그렇지 않으면 completion을 빈 배열을 준다
                    completion([]) // completion부분에 아무것도 정보를 담지 않는다.
                    return
            }
            
            guard let resultData = data else {
                // 위의 error이 없는걸 확인했고, dataTask의 data를 결과테이터 변수에 대입하는데, 이 작업이 실패하면 completion에 빈배열 주고 리턴
                completion([])
                return
            }
            
            let movies = SearchAPI.parseMovies(resultData) //
            completion(movies)
        }
        dataTask.resume() // 3. resume으로 데이터 받아오기
    }
    
    static func parseMovies(_ data: Data) -> [Movie] { // 타입메소드로 선언
        let decoder = JSONDecoder() // 1. 디코더 선언하고

        do {
            let response = try decoder.decode(Response.self, from: data) // data로부터 Response타입으로 디코딩!
            let movies = response.movies
            return movies
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
    }
}

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}

struct Movie: Codable {
    let title: String
    let director: String
    let thumbnailPath: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
    }
}
