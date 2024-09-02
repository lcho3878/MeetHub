//
//  PayViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 9/2/24.
//

import UIKit
import SnapKit
import WebKit
import iamport_ios

final class PayViewController:BaseViewController {
    
    private let wkWebView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("PayVC Load")
        configureView()
        requestLoad()
    }
    
    private func configureView() {
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func requestLoad() {
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(Key.key)_\(Int(Date().timeIntervalSince1970))",
            amount: "100").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = "개발자에게 후원하기"
                $0.buyer_name = "이찬호"
                $0.app_scheme = "sesac"
        }
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: "imp57573124",
            payment: payment) { [weak self] iamportResponse in
                print(String(describing: iamportResponse))
                if iamportResponse?.success == true {
                    print(iamportResponse?.imp_uid)
                    let query = PayValidationQuery(imp_uid: (iamportResponse?.imp_uid)!, post_id: "66d4a1635a9c85013f8eeab7")
                    APIManager.shared.callTest(api: .payValidation(query: query), type: PayValidationResponseModel.self) { result in
                        self?.showAlert(content: "결제 성공") {
                            self?.dismiss(animated: true)
                        }
                    }
                }
                else {
                    self?.showAlert(content: "결제가 실패했습니다.") {
                        self?.dismiss(animated: true)
                    }
                }
            }
    }
}
