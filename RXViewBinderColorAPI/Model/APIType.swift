//
//  APIType.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import Foundation

enum APIType {
    case colors
}

enum APIUrl {
    private static var base: URL {
        URL(string: "https://raw.githubusercontent.com/wlsdms0122/RxMVVM/develop")!
    }
    
    static func url(_ type: APIType) -> URL {
        var path: String
        switch type {
        case .colors:
            path = "API/colors.json"
        }
        return APIUrl.base.appendingPathComponent(path)
    }
}
