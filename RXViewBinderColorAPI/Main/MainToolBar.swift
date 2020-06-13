//
//  MainToolBar.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import UIKit
import SnapKit

class MainToolBar: UIView {
    weak var favoriteButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorLists.gray5
        
        let favoriteButton = UIButton()
        favoriteButton.tintColor = ColorLists.label
        if #available(iOS 13.0, *) {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        } else {
            favoriteButton.setTitle("HEART", for: .normal)
        }
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(favoriteButton)
        
        favoriteButton.snp.makeConstraints {
            $0.leading.equalTo(self.layoutMarginsGuide.snp.leading)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
        }
        
        
        self.favoriteButton = favoriteButton
        
        let refreshButton = UIButton()
        refreshButton.tintColor = ColorLists.label
        
        if #available(iOS 13.0, *) {
            refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        } else {
            refreshButton.setTitle("REFRESH", for: .normal)
        }
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(refreshButton)
        
        
        refreshButton.snp.makeConstraints {
            $0.trailing.equalTo(self.layoutMarginsGuide.snp.trailing)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
