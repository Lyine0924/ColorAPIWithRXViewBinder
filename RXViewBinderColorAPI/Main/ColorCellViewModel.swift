//
//  ColorCellViewModel.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import Foundation

protocol ColorCellViewModelOutput {
    var color: Color { get }
}

protocol ColorCellViewModelType {
    var output: ColorCellViewModelOutput { get }
}

class ColorCellViewModel: ColorCellViewModelType, ColorCellViewModelOutput {
    var output: ColorCellViewModelOutput { self }
    var color: Color
    
    init(_ color: Color) {
        self.color = color
    }
}
