//
//  APICaller.swift
//  NewsApp
//
//  Created by User on 21/10/22.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    struct Constants {
        static let topHeadlinesURL = URL( string:
        "https://newsapi.org/v2/everything?q=Apple&from=2022-10-21&sortBy=popularity&apiKey=005903fdf65c4addafd0c53319cd078c")
    }
    private init(){}
    
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse .self, from: data)
                    
                    print("Result: \(result.articles.count)")
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
                
            }
        }
        
        task.resume()
    }
}

// MARK: Model of news

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}


