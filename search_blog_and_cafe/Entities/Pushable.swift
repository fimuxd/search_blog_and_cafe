//
//  Pushable.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import UIKit
import SafariServices

protocol Pushable {
    func push(from: UINavigationController) throws
}

enum PushableView: Pushable {
    case detailView(DetailViewBindable)
    case safariView(URL?)
    
    func push(from: UINavigationController) throws {
        switch self {
        case .detailView(let viewModel):
            let viewController = DetailViewController()
            viewController.bind(viewModel)
            
            from.pushViewController(
                viewController,
                animated: true
            )
        case .safariView(let url):
            guard let url = url else { return }
            from.present(
                SFSafariViewController(url: url),
                animated: true,
                completion: nil
            )
        }
    }
}
