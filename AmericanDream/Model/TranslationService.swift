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
    private init() {}
    private var task: URLSessionDataTask?
    
    func translate(textToTranslate: String, callback: @escaping (Bool, String?) -> Void) {
        var request = URLRequest(url: TranslationService.urlApi)
        request.httpMethod = "POST"
        let body = "key=AIzaSyDaQLJNCHFuKw9XUTMSNcGIZWCCySTDiTA&q=\(textToTranslate)&target=fr&source=en"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        
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
                let textToTransmit = translation.data["translations"]![0]["translatedText"]!
                callback(true,textToTransmit)
            }
        }
        task?.resume()
    }
    
}

struct DataFromGT: Decodable {
    let data : [String : [[String:String]]]
    
    init(data: [String : [[String:String]]]) {
        self.data = data
    }
}


