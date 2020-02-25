//
//  BaseViewController.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol BaseViewBindable {
    var mainViewModel: MainViewBindable { get }
}

class BaseViewController: UINavigationController {
    let mainViewController = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [mainViewController]
    }
    
    func bind(_ viewModel: BaseViewBindable) {
        mainViewController.bind(viewModel.mainViewModel)
    }
}
