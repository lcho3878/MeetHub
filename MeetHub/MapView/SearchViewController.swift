//
//  SearchViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/29/24.
//

import UIKit
import RxSwift

final class SearchViewController: BaseViewController {
    
    weak var delegate: MarkerUpdateDelegate?
    
    private let searchView = SearchView()
    
    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = SearchViewModel.Input(queryInput: searchView.searchTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        let resultOutput = output.resultOutput.share()
        
        searchView.searchTableView.rx.modelSelected(Place.self)
            .bind(with: self) { owner,place in
                print("lat: \(place.lat), lon: \(place.lon)")
                let coord = Coord(lat: place.lat, lon: place.lon)
                owner.delegate?.updateMarker(coord)
                print("delegate실행")
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        resultOutput
            .bind(to: searchView.searchTableView.rx.items(cellIdentifier: SearchTableViewCell.id, cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.configureDate(element)
            }
            .disposed(by: disposeBag)
        
        resultOutput
            .bind(with: self) { owner, items in
                owner.searchView.searchTableView.isHidden = items.isEmpty
            }
            .disposed(by: disposeBag)
    }
}


class SearchTableViewCell: UITableViewCell {
    
    let label1 = {
        let view = UILabel()
        view.text = "레이블1"
        return view
    }()
    let label2 = {
        let view = UILabel()
        view.text = "레이블2"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    func configureView() {
        contentView.addSubview(label1)
        contentView.addSubview(label2)
        
        label1.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        
        label2.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureDate(_ data: Place) {
        label1.text = data.cleanTitle
        label2.text = data.roadAddress
    }
}

struct Response: Decodable, ResponseModel {
    let items: [Place]
    
    struct ErrorModel: ResponseError {
        var responseCode: Int?
        
        init(responseCode: Int? = nil) {
            self.responseCode = responseCode
        }
        
        var errorMessage: String {
            switch responseCode {
            default: return ""
            }
        }
    }
}

struct Place: Decodable {
    let title: String
    let address: String
    let roadAddress: String
    let mapx: String
    let mapy: String
    
    var cleanTitle: String {
        var cleanTitle = title
        cleanTitle = cleanTitle.replacingOccurrences(of: "<b>", with: "")
        cleanTitle = cleanTitle.replacingOccurrences(of: "</b>", with: "")
        return cleanTitle
    }
    
    var lat: Double {
        let y = Double(mapy)!
        return y / pow(10, 7)
    }
    var lon: Double {
        let x = Double(mapx)!
        return x / pow(10, 7)
    }
    
}

