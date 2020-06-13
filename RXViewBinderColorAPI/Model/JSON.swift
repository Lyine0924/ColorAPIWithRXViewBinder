//
//  JSON.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func decodeOptional<T: Codable>(_ data: Data, type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
}
