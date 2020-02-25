//
//  DetailWebViewController.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import WebKit
import RxSwift
import RxCocoa

protocol DetailWebViewBindable {
    var urlRequest: URLRequest { get }
    var title: String { get }
}

class DetailWebViewController: UIViewController {
    var disposeBag = DisposeBag()
    let webView = WKWebView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailWebViewBindable) {
        self.disposeBag = DisposeBag()
        
        title = viewModel.title
        _ = webView.load(viewModel.urlRequest)
    }
    
    private func layout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
