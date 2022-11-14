//
//  HomeViewController.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
