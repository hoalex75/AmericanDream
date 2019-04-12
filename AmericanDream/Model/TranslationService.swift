//
//  TranslationService.swift
//  AmericanDream
//
//  Created by Alex on 10/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

class TranslationService {
    static var shared = TranslationService()
    private static let urlApi = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    private static let apiKey = "AIzaSyDaQLJNCHFuKw9XUTMSNcGIZWCCySTDiTA"
    private init() {}
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession){
        self.session = session
    }
    
    func translate(textToTranslate: String, callback: @escaping (Bool, String?) -> Void) {
        var request = URLRequest(url: TranslationService.urlApi)
        request.httpMethod = "POST"
        let body = "key=\(TranslationService.apiKey)&q=\(textToTranslate)&target=en&source=fr&format=text"
        request.httpBody = body.data(using: .utf8)
        
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false,nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false,nil)
                    return
                }
                guard let translation = try? JSONDecoder().decode(DataFromGT.self, from: data) else {
                    callback(false,nil)
                    return
                }
                let textToTransmit = translation.data.translations[0].translatedText
                callback(true,textToTransmit)
            }
        }
        task?.resume()
    }
    
}

struct DataFromGT: Decodable {
    let data: Translation
    
    init(data: Translation){
        self.data = data
    }
}

struct Translation: Decodable {
    let translations: [TranslatedText]
    
    init(translations: [TranslatedText]) {
        self.translations = translations
    }
}

struct TranslatedText: Decodable {
    let translatedText: String
    
    init(translatedText: String) {
        self.translatedText = translatedText
    }
}

