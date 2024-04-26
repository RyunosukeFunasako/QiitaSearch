import SwiftUI

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let userId: String
    let profileImageUrl: URL
    let likesCount: Int
    let url: URL
}

class QiitaData: ObservableObject {
    struct ResultJson: Codable {
        let title: String?
        let user: User?
        let likesCount: Int?
        let url: URL?
    }
    
    struct User: Codable {
        let id: String?
        let profileImageUrl: URL?
    }
    
    @Published var articleList: [Article] = []
    @Published var articleLink: URL?
    
    func searchQiita(keyword: String) {
        Task {
            await search(keyword: keyword)
        }
    }
    
    @MainActor
    private func search(keyword: String) async {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let req_url = URL(string: "https://qiita.com/api/v2/items?query=tag:\(keyword_encode)&page=1&per_page=30") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: req_url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let json = try decoder.decode([ResultJson].self, from: data)
            articleList.removeAll()
            
            for item in json {
                if let title = item.title,
                   let userId = item.user?.id,
                   let profileImageUrl = item.user?.profileImageUrl,
                   let likesCount = item.likesCount,
                   let url = item.url {
                    let article = Article(title: title, userId: userId, profileImageUrl: profileImageUrl, likesCount: likesCount, url: url)
                    articleList.append(article)
                }
            }
        } catch {
            print("エラーが出ました")
        }
    }
}
