//
//  NetworkService.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import Foundation
import RxSwift

enum APIProviderError: Error {
    case parseError
    case unknownError
}

class NetworkService {
    func fetchColors() -> Single<[Color]> {
        APIProvider.request(.colors)
    }
}

// MARK: - API Provider
fileprivate struct APIProvider {
    static func request(_ type: APIType) -> Single<[Color]> {
        return Single.create { emitter in
            let session: URLSession = URLSession.init(configuration: .default)
            session.dataTask(with: APIUrl.url(type)) { (data: Data?, response: URLResponse?, error: Error?) in
                if let _ = error {
                    emitter(.error(APIProviderError.unknownError))
                }
                
                guard let jsonData = data else {
                    emitter(.error(APIProviderError.parseError))
                    return
                }
                
                guard let model = JSONDecoder.decodeOptional(jsonData,type:[Color].self) else {
                    emitter(.error(APIProviderError.parseError))
                    return
                }
                
                emitter(.success(model))
                
            }.resume()
            
            return Disposables.create()
        }
    }
}


