//
//  MainViewModel.swift
//  RXViewBinderColorAPI
//
//  Created by Lyine on 2020/06/07.
//  Copyright © 2020 Lyine. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias ColorCellSection = SectionModel<Void, ColorCellViewModelType>

protocol MainViewModelInput {
    func favoriteButtonPressed()
    func fetchData()
}

protocol MainViewModelOutput {
    var color: Driver<[ColorCellSection]> { get }
    var isLoading: Driver<Bool> { get }
    var isFavorite: Driver<Bool> { get }
    var error: Driver<String?> { get }
}

protocol MainViewModelType {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    var input: MainViewModelInput { return self }
    var output: MainViewModelOutput { return self }

    let networkService: NetworkService
    let disposeBag = DisposeBag()

    // state
    private var _color: BehaviorRelay<[ColorCellSection]> = .init(value: [])
    private var _isLoading: BehaviorRelay<Bool> = .init(value: false)
    private var _isFavorite: BehaviorRelay<Bool> = .init(value: false)
    private var _error: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    lazy var isLoading: Driver<Bool> = _isLoading.asDriver()
    lazy var color: Driver<[ColorCellSection]> = _color.asDriver()
    lazy var isFavorite: Driver<Bool> = _isFavorite.asDriver()
    lazy var error: Driver<String?> = _error.asDriver()

    init(_ networkService: NetworkService = NetworkService()) {
        self.networkService = networkService

        self._isFavorite.withLatestFrom(_color)
            .do(onNext: { _ in self.fetchData() })
            .bind(to: self._color)
            .disposed(by: disposeBag)
    }

    func favoriteButtonPressed() {
        self._isFavorite.accept(!self._isFavorite.value)
    }

    func fetchData() {
        self._isLoading.accept(true)

        var colors = networkService.fetchColors()

        if self._isFavorite.value {
            colors = colors.map { $0.filter { $0.isFavorite } }
        }

        colors
            .asObservable()
            .catchError({ error in
                self._error.accept(error.localizedDescription)
                return .empty()
            })
            .map { $0.map { ColorCellViewModel($0) } }
            .map { ([ColorCellSection(model: Void(), items: $0)])}
            .do(onCompleted: { [weak self] in self?._isLoading.accept(false) })
            .bind(to: self._color)
            .disposed(by: disposeBag)
    }
}
