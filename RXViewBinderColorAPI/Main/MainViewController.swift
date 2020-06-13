//
//  ViewController.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewBinder
import SnapKit

enum Cell {
    static let colorCell = "\(ColorCell.self)"
}

class MainViewController: UIViewController, BindView {
    typealias ViewBinder = MainViewBindable

    weak var tableView: UITableView?
    weak var indicator: UIActivityIndicatorView?
    weak var toolBar: MainToolBar!

    private let dataSource = RxTableViewSectionedReloadDataSource<ColorCellSection>(configureCell: {
        dataSource, tableView, indexPath, viewModel in

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.colorCell, for: indexPath) as? ColorCell else {
            return UITableViewCell()
        }

        cell.viewModel = viewModel
        return cell
    })

    init(viewBindable: ViewBinder = MainViewBindable()) {
        super.init(nibName: nil, bundle: nil)
        self.viewBinder = viewBindable
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = ColorLists.background
        self.view = view

        let toolbar = MainToolBar()
        self.toolBar = toolbar

        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        
        toolbar.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44).priority(.high)
        }

        // tableView
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView = tableView
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(toolbar.snp.top)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }

        tableView.register(ColorCell.self, forCellReuseIdentifier: Cell.colorCell)
        tableView.delegate = self

        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        indicator.layer.cornerRadius = 10
        indicator.clipsToBounds = true

        self.indicator = indicator
        view.addSubview(indicator)

        indicator.translatesAutoresizingMaskIntoConstraints = true
        
        indicator.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(60)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
        }
    }

    override func viewDidLoad() {
//        super.viewDidLoad()
        self.navigationItem.title = "색상 목록"
        // Do any additional setup after loading the view.
    }

    func state(viewBinder: MainViewBindable) {
        viewBinder.state
            .color
            .drive(tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewBinder.state
            .isLoading
            .drive(onNext: { [weak self] in
                $0 ? self?.indicator?.startAnimating() : self?.indicator?.stopAnimating()
            })
            .disposed(by: disposeBag)

        viewBinder.state
            .isFavorite
            .drive(toolBar.favoriteButton!.rx.isSelected)
            .disposed(by: disposeBag)

        viewBinder.state
            .error
            .asObservable()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                let alertViewController = UIAlertController(title: nil, message: $0, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "확인", style: .default))

                self?.present(alertViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func command(viewBinder: MainViewBindable) {
        self.toolBar.favoriteButton!.rx.tap
            .map { _ in MainViewBindable.Command.pressed }
            .bind(to: viewBinder.command)
            .disposed(by: disposeBag)

        self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in ViewBinder.Command.fetch }
            .bind(to: viewBinder.command)
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ColorCell {
            print(cell.viewModel?.output.color)
        }
    }
}
