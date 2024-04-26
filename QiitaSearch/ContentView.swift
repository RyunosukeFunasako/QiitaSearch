import SwiftUI

struct ContentView: View {
    @StateObject var qiitaDataList = QiitaData()
    @State var inputText = ""
    @State var isShowSafari = false
    
    var body: some View {
        VStack {
            TextField("キーワード",
                      text: $inputText,
                      prompt: Text("キーワードを入力してください。例：Python"))
            .padding()
            .background(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.green), alignment: Alignment.bottom
            )
            .onSubmit {
                qiitaDataList.searchQiita(keyword: inputText)
            }
            .submitLabel(.search)
            .padding()
            
            if qiitaDataList.articleList.isEmpty {
                Text("該当記事なし")
            }

            List(qiitaDataList.articleList) { article in
                Button {
                    qiitaDataList.articleLink = article.url
                    isShowSafari.toggle()
                } label: {
                    HStack {
                        AsyncImage(url: article.profileImageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(article.title)
                            .font(.headline)
                        Spacer()
                        Text("♡: \(article.likesCount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(isPresented: $isShowSafari, content: {
                // SafariViewを表示する
                SafariView(url: qiitaDataList.articleLink!)
                    .ignoresSafeArea(edges: [.bottom])
            })
        }
    }
}

#Preview {
    ContentView()
}
