//
//  TotalCVViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/03.
//

import RxSwift
import SnapKit
import UIKit
import Then

class TotalCVViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: TotalCVViewModel = .init()
    
    let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .systemBlue
        $0.text = "Hello, World!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSubviews()
        
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
    
private extension TotalCVViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    func configureSubviews() {
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
    

