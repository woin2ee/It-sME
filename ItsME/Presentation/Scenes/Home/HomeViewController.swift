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
    
    private lazy var editProfileButton: UIButton = {
        let action = UIAction { _ in
            let editProfileVC: EditProfileViewController = .init()
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
        
        let button = UIButton(type: .system, primaryAction: action)
        button.backgroundColor = .mainColor
        button.setTitle("프로필 수정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var vStackLayout = UIStackView()
    
    
    private var hStackLayout = UIStackView()
    
    private var cardScrollView = UIScrollView()
    
    private lazy var pageController = UIPageControl()
    
    let contentWidth = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        vStackLayout.removeAllArrangedSubviews()
        hStackLayout.removeAllArrangedSubviews()
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
            targetContentOffset.pointee.x = pageOffset
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
        let croppedView = 40
        let padding = hStackLayout.layoutMargins.left
        return (0..<numberOfPages).map { CGFloat(Float($0)) * (padding + CGFloat(contentWidth) - CGFloat(croppedView))}
    }
}

// MARK: - Binding ViewModel

private extension HomeViewController {
    
    func bindViewModel() {
        let input = makeInput()
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive(userInfoBinding)
            .disposed(by: disposeBag)
        
        output.cvsInfo
            .drive(cvsInfoBinding)
            .disposed(by: disposeBag)
    }
    
    func makeInput() -> HomeViewModel.Input {
        let viewDidLoad = Observable.just(())
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        return .init(
            viewDidLoad: viewDidLoad,
            viewWillAppear: viewWillAppear
        )
    }
    
    var userInfoBinding: Binder<UserInfo> {
        return .init(self) { viewController, userInfo in
            
            userInfo.defaultItems.forEach { item in
                let profileInfo: ProfileInfoComponent = .init(userInfoItem: item)
                self.vStackLayout.addArrangedSubview(profileInfo)
            }
            
            self.vStackLayout.snp.makeConstraints { make in
                make.height.equalTo((self.vStackLayout.arrangedSubviews.count * 40))
                make.width.equalTo(self.view.snp.width).multipliedBy(0.6)
                make.centerX.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(self.profileImageView.snp.bottom).offset(20)
            }
        }
    }
    
    var cvsInfoBinding: Binder<[CVInfo]> {
        return .init(self) { viewController, cvsInfo in
            cvsInfo.forEach { cvInfo in
                let cvCard = CVCard()
                cvCard.cvTitle.text = cvInfo.title
                cvCard.latestDate.text = "최근 수정일: " + cvInfo.lastModified
                cvCard.layer.cornerRadius = 10
                cvCard.backgroundColor = .mainColor
                self.hStackLayout.addArrangedSubview(cvCard)
                cvCard.snp.makeConstraints{ make in
                    make.width.equalTo(self.contentWidth)
                }
            }
        }
    }
}

// MARK: - Private functions

private extension HomeViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    func configureSubviews() {
        self.view.addSubview(editProfileButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(vStackLayout)
        cardScrollView.addSubview(hStackLayout)
        self.view.addSubview(cardScrollView)
        self.view.addSubview(pageController)
        
        profileImageView.contentMode = .scaleAspectFill
        
        vStackLayout.axis = .vertical
        vStackLayout.distribution = .fillEqually
        
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
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.4)
            make.centerX.equalTo(self.view)
            make.top.equalTo(editProfileButton.snp.bottom).offset(20)
        }
        
        hStackLayout.snp.makeConstraints{ make in
            make.height.left.right.equalToSuperview()
        }
        
        cardScrollView.snp.makeConstraints{ make in
            make.top.equalTo(vStackLayout.snp.bottom).offset(30)
            make.bottom.equalTo(self.view.snp.bottom).offset(-30)
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
// MARK: - for Paging
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
