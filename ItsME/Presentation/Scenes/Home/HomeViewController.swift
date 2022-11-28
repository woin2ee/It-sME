//
//  HomeViewController.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import UIKit
import RxSwift
import SnapKit

final class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    
    
    private var disposeBag: DisposeBag = .init()
    
    private let viewModel: HomeViewModel = .init()
    
    private let profileImageView: UIImageView = {
        
        let profileImageView: UIImageView = .init(image: UIImage.init(named: "테스트이미지"))
        return profileImageView
    }()
    
    private let editProfileButton: UIButton = {
        let button: UIButton = .init()
        return button
    }()
    
    private var profileInfo: ProfileInfoComponent = .init(userInfoItem: .init(icon: .computer, contents: "asdfasdfasdfasdfklahsdfadhgladfljglakdghlijadfglkjahl"))
    
    private var vStackLayout = UIStackView()
    
    private let cvCard = CVCard()
    private let cvCard2 = CVCard()
    private let cvCard3 = CVCard()
    
    private var hStackLayout = UIStackView()
    
    private var cardScrollView = UIScrollView()
    
    private lazy var pageController = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.circular()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let pageOffset = ScrollPageController().pageOffset(
            for: scrollView.contentOffset.x,
            velocity: velocity.x,
            in: pageOffsets(in: scrollView)
        ) {
            print(targetContentOffset.pointee.x,"askjdhfhㄴga")
            targetContentOffset.pointee.x = pageOffset
            print(targetContentOffset.pointee.x,"askjdhfhga")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if let pageFraction = ScrollPageController().pageFraction(
                for: scrollView.contentOffset.x,
                in: pageOffsets(in: scrollView)
            ) {
                let pageControl: UIPageControl = pageController
                pageControl.currentPage = Int(round(pageFraction))
            }
        }
    
    private func pageOffsets(in scrollView: UIScrollView) -> [CGFloat] {
        let pageWidth = scrollView.bounds.width
        - scrollView.adjustedContentInset.left
        - scrollView.adjustedContentInset.right
        let numberOfPages = Int(ceil(scrollView.contentSize.width / pageWidth))
        print(pageWidth, numberOfPages,scrollView.contentSize.width,"!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@!@!@#!@!!@#!@#!@#!@#!@#!@#!@#!@#")
        let test = [CGFloat(0),CGFloat(280),CGFloat(560)]
        print(test)
//        return (0..<numberOfPages).map { CGFloat($0) * pageWidth - scrollView.adjustedContentInset.left }
        return test
    }
}

// MARK: - Private functions

private extension HomeViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = HomeViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive(onNext: { userInfo in
                // input 에 대한 output 으로 userInfo 를 받았을 때 수행할 작업 정의
                print(userInfo)
            })
            .disposed(by: disposeBag)
    }
    
    func configureSubviews() {
        self.view.addSubview(editProfileButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(vStackLayout)
        cardScrollView.addSubview(hStackLayout)
        self.view.addSubview(cardScrollView)
        self.view.addSubview(pageController)
        
        editProfileButton.backgroundColor = .mainColor
        editProfileButton.setTitle("프로필 수정", for: .normal)
        editProfileButton.layer.cornerRadius = 10
        profileImageView.contentMode = .scaleAspectFill
        
        vStackLayout.addArrangedSubview(profileInfo)
        vStackLayout.axis = .vertical
        vStackLayout.distribution = .fillEqually
        vStackLayout.spacing = 5
        
        cvCard.layer.cornerRadius = 10
        cvCard.backgroundColor = .mainColor
        cvCard2.layer.cornerRadius = 10
        cvCard2.backgroundColor = .mainColor
        cvCard3.layer.cornerRadius = 10
        cvCard3.backgroundColor = .mainColor
        
        hStackLayout.addArrangedSubview(cvCard)
        hStackLayout.addArrangedSubview(cvCard2)
        hStackLayout.addArrangedSubview(cvCard3)
        hStackLayout.axis = .horizontal
        hStackLayout.distribution = .fillEqually
        hStackLayout.alignment = .fill
        hStackLayout.spacing = 30
        hStackLayout.isLayoutMarginsRelativeArrangement = true
        hStackLayout.layoutMargins.right = 70
        hStackLayout.layoutMargins.left = hStackLayout.layoutMargins.right
        
        cardScrollView.delegate = self
        cardScrollView.isScrollEnabled = true
        cardScrollView.alwaysBounceHorizontal = true
        cardScrollView.layoutMargins = .zero
        cardScrollView.showsHorizontalScrollIndicator = false
        
        pageController.hidesForSinglePage = true
        pageController.pageIndicatorTintColor = .gray
        pageController.currentPageIndicatorTintColor = .black
        pageController.backgroundColor = .mainColor
        
        editProfileButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.trailing.equalTo(-30)
            make.top.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
            make.centerX.equalTo(self.view)
            make.top.equalTo(editProfileButton.snp.bottom).offset(20)
        }
        
        vStackLayout.snp.makeConstraints { make in
            make.height.equalTo((vStackLayout.arrangedSubviews.count * 40))
            make.width.equalTo(300)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        hStackLayout.snp.makeConstraints{ make in
            make.height.left.right.equalToSuperview()
            make.width.equalTo(950)
        }
        
        cardScrollView.snp.makeConstraints{ make in
            make.top.equalTo(vStackLayout.snp.bottom).offset(70)
            make.height.equalTo(250)
            make.width.equalToSuperview()
        }
        
        pageController.snp.makeConstraints{ make in
            make.top.equalTo(cardScrollView.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

struct ScrollPageController {
    
    /// Computes page offset from page offsets array for given scroll offset and velocity
    ///
    /// - Parameters:
    ///   - offset: current scroll offset
    ///   - velocity: current scroll velocity
    ///   - pageOffsets: page offsets array
    /// - Returns: target page offset from array or nil if no page offets provided
    func pageOffset(for offset: CGFloat, velocity: CGFloat, in pageOffsets: [CGFloat]) -> CGFloat? {
        let pages = pageOffsets.enumerated().reduce([Int: CGFloat]()) {
            var dict = $0
            dict[$1.0] = $1.1
            return dict
        }
        guard let page = pages.min(by: { abs($0.1 - offset) < abs($1.1 - offset) }) else {
            return nil
        }
        if abs(velocity) < 0.2 {
            return page.value
        }
        if velocity < 0 {
            return pages[pageOffsets.index(before: page.key)] ?? page.value
        }
        print(pages[pageOffsets.index(after: page.key)] ?? page.value,"왜")
        return pages[pageOffsets.index(after: page.key)] ?? page.value
    }
    
    /// Cumputes page fraction from page offsets array for given scroll offset
    ///
    /// - Parameters:
    ///   - offset: current scroll offset
    ///   - pageOffsets: page offsets array
    /// - Returns: current page fraction in range from 0 to number of pages or nil if no page offets provided
    func pageFraction(for offset: CGFloat, in pageOffsets: [CGFloat]) -> CGFloat? {
        let pages = pageOffsets.sorted().enumerated()
        if let index = pages.first(where: { $0.1 == offset })?.0 {
            return CGFloat(index)
        }
        guard let nextOffset = pages.first(where: { $0.1 >= offset })?.1 else {
            return pages.map { $0.0 }.last.map { CGFloat($0) }
        }
        guard let (prevIdx, prevOffset) = pages.reversed().first(where: { $0.1 <= offset }) else {
            return pages.map { $0.0 }.first.map { CGFloat($0) }
        }
        return CGFloat(prevIdx) + (offset - prevOffset) / (nextOffset - prevOffset)
    }
    
}


//MARK: - for canvas
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = HomeViewController
    
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
    }
}

@available(iOS 15.0.0, *)
struct HomeViewControllerPrivew: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
