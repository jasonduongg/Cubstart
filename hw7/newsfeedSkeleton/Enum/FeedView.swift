//
//  FeedView.swift
//  newsfeedSkeleton
//
//  Created by saerom on 4/7/22.
//

import SwiftUI
import Combine

struct FeedView: View {
    
    @Environment(\.openURL) var openURL
    @StateObject var viewModel: ArticleViewModelImpl = ArticleViewModelImpl(service: ArticleServiceImpl())
    
    var body: some View{
        NavigationView {
            
            Group {
                
                switch viewModel.state{
                case .loading:
                    ProgressView()
                case .failed(let error):
                    ErrorView(error: error){
                        self.viewModel.getArticles()
                    }
                case .success(let content):
                    List(content) {article in
                        ArticleView(article: article)
                            .onTapGesture {
                                load(url: article.url)
                            }
                    }
                    .navigationBarTitle("News")
                }
            }
        }
        .onAppear{
            print("FeedView has appeared")
            self.viewModel.getArticles()
        }
    }
    func load(url: String?){
        guard let url = url,
                let linkUrl = URL(string: url) else {
                    return
                }
        openURL(linkUrl)
    }
}


