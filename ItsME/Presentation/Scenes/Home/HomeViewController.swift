//
//  HomeViewController.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import FirebaseStorage
import UIKit
import RxSwift
import SnapKit
import Then

final class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    private var disposeBag: DisposeBag = .init()
    
    private let viewModel: HomeViewModel = .init()
    
    private let profileImageView: UIImageView = {
        let profileImageView: UIImageView = .init(image: UIImage.init(named: "테스트이미지"))
        return profileImageView
    }()
    
    private lazy var profileEditingButton: UIButton = {
        let action = UIAction { _ in
            let profileEditingViewModel: ProfileEditingViewModel = .init(
                initalProfileImage: self.profileImageView.image?.jpegData(compressionQuality: 1.0),
                userInfo: self.viewModel.userInfo
            )
            let profileEditingViewController: ProfileEditingViewController = .init(viewModel: profileEditingViewModel)
            let profileEditingNavigationController: UINavigationController = .init(rootViewController: profileEditingViewController)
            profileEditingNavigationController.modalTransitionStyle = .coverVertical
            profileEditingNavigationController.modalPresentationStyle = .fullScreen
            self.present(profileEditingNavigationController, animated: true)
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
    
    private lazy var addCVButton: AddCVButton = .init()
    
    let contentWidth = 250
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
            .mapToVoid()
            .asSignalOnErrorJustComplete()
        
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .mapToVoid()
            .asSignalOnErrorJustComplete()
        
        return .init(
            viewDidLoad: viewDidLoad,
            viewWillAppear: viewWillAppear
        )
    }
    
    var userInfoBinding: Binder<UserInfo> {
        return .init(self) { viewController, userInfo in
            
            self.vStackLayout.removeAllArrangedSubviews()
            userInfo.defaultItems.forEach { item in
                let profileInfo: ProfileInfoComponent = .init(userInfoItem: item)
                self.vStackLayout.addArrangedSubview(profileInfo)
            }
            
            let ref = Storage.storage().reference().child(userInfo.profileImageURL)
            ref.getData(maxSize: 3 * 1024 * 1024) { data, error in
                if let error = error {
                    // TODO: Error 처리 (ex: Toast message 출력)
                    #if DEBUG
                        print(error)
                    #endif
                    return
                }
                
                guard let data = data else {
                    // TODO: Error 처리 (ex: Toast message 출력)
                    return
                }

                viewController.profileImageView.image = .init(data: data)
            }
        }
    }
    
    var cvsInfoBinding: Binder<[CVInfo]> {
        return .init(self) { vc, cvsInfo in
            
            vc.hStackLayout.removeAllArrangedSubviews()
            
            cvsInfo.sorted(by: { $0.lastModified > $1.lastModified })
                .enumerated()
                .forEach { (index, cvInfo) in
                    let cvCard = CVCard().then {
                        $0.cvTitle.text = cvInfo.title
                        $0.latestDate.text = "최근 수정일: " + cvInfo.lastModified
                        $0.layer.cornerRadius = 10
                        $0.backgroundColor = .mainColor
                    }
                    vc.hStackLayout.addArrangedSubview(cvCard)
                    
                    cvCard.snp.makeConstraints{ make in
                        make.width.equalTo(vc.contentWidth)
                    }
                    
                    let pushAction: UIAction = .init { _ in
                        let totalCVViewModel: TotalCVViewModel = .init(cvInfo: cvInfo)
                        let totalCVVC: TotalCVViewController = .init(viewModel: totalCVViewModel)
                        vc.navigationController?.pushViewController(totalCVVC, animated: true)
                    }
                    cvCard.addAction(pushAction, for: .touchUpInside)
                }
                
                cvCard.addAction(UIAction{ _ in
                    let totalCVVC: TotalCVViewController = .init(viewModel: TotalCVViewModel.init(cvInfo: cvInfo, index: index))
                    
                    self.navigationController?.pushViewController(totalCVVC, animated: true)
                    
                }, for: .touchUpInside)
            }
            self.layoutAddCVButton()
        }
    }
}

// MARK: - Private functions

private extension HomeViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureSubviews() {
        self.view.addSubview(profileEditingButton)
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
        
        profileEditingButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.trailing.equalTo(-30)
            make.top.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.4)
            make.centerX.equalTo(self.view)
            make.top.equalTo(profileEditingButton.snp.bottom).offset(20)
        }
        
        vStackLayout.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width).multipliedBy(0.8)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.profileImageView.snp.bottom).offset(20)
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

// MARK: - Private Function
extension HomeViewController {
    
    func pushCVAddView() {
        let cvAddViewModel: CVAddViewModel = .init(cvTitle: "", editingType: .new)
        let viewController: CVAddViewController = .init(viewModel: cvAddViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func makeCVAction() -> UIAction {
        return UIAction(
            identifier: UIAction.Identifier("CVIdentifier"),
            handler: { [weak self] action in
                self?.pushCVAddView()
            })
    }
    
    func layoutAddCVButton() {
        addCVButton.title.text = "CV 추가"
        addCVButton.title.textColor = .mainColor
        addCVButton.title.textAlignment = .center
        addCVButton.title.font = .systemFont(ofSize: 30, weight: .bold)
        
        addCVButton.addImage.image =  UIImage(systemName: "plus.rectangle.portrait.fill")
        addCVButton.backgroundColor = .systemBackground
        addCVButton.tintColor = .mainColor
        
        self.hStackLayout.addArrangedSubview(addCVButton)
        addCVButton.snp.makeConstraints{ make in
            make.width.equalTo(self.contentWidth)
            make.verticalEdges.equalToSuperview()
        }
        addCVButton.addAction(makeCVAction(), for: .touchUpInside)
    }
}
