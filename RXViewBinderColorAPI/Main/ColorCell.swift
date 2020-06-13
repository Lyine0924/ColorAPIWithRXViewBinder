//
//  ColorCell.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import UIKit
import SnapKit

class ColorCell: UITableViewCell {
    private weak var previewColor: UIView?
    private weak var titleLabel: UILabel?
    private weak var hexCodeLabel: UILabel?

    var viewModel: ColorCellViewModelType? {
        didSet {
            guard let viewModel = self.viewModel else { return }

            let output = viewModel.output
            self.previewColor?.backgroundColor = UIColor.init(hex: output.color.hex)
            self.titleLabel?.text = output.color.name
            self.hexCodeLabel?.text = output.color.hex
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let previewColor = UIView()
        previewColor.layer.cornerRadius = 12
        self.contentView.addSubview(previewColor)

        previewColor.translatesAutoresizingMaskIntoConstraints = false
        
        previewColor.snp.makeConstraints {
            $0.width.equalTo(previewColor.snp.height)
            $0.leading.equalTo(contentView.layoutMarginsGuide.snp.leading)
            $0.top.equalTo(contentView.layoutMarginsGuide.snp.top).offset(4)
            $0.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom).offset(-4)
            $0.height.equalTo(64).priority(.high)
        }

        self.previewColor = previewColor

        /**
         Self-Sizeing Cell 구현시 셀의 높이가 constatnt면 에러가 발생할 때 해결하는 방법 -> 우선순위 조정
         */

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = ColorLists.label
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(previewColor.snp.top)
            $0.leading.equalTo(previewColor.snp.trailing).offset(12)
        }
        
        self.titleLabel = titleLabel

        let hexCodeLabel = UILabel()
        hexCodeLabel.font = .systemFont(ofSize: 16)
        hexCodeLabel.textColor = ColorLists.label
        contentView.addSubview(hexCodeLabel)
        hexCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hexCodeLabel.snp.makeConstraints {
            $0.bottom.equalTo(previewColor.snp.bottom)
            $0.leading.equalTo(previewColor.snp.trailing).offset(12)
        }
        
        
        self.hexCodeLabel = hexCodeLabel
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
