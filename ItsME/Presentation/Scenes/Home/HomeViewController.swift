//
//  HomeViewController.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import FirebaseStorage
import ItsMEUtil
import UIKit
import RxSwift
import SFSafeSymbols
import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: HomeViewModel
    
    private var deviceWidth: CGFloat {
        return view.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    private var contentWidth: CGFloat {
        return deviceWidth * 0.64
    }
    
    // MARK: UI Objects
    
    private let profileImageView: UIImageView = .init().then {
        $0.image = .defaultProfileImage
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var profileEditingButton: UIButton = {
        let action = UIAction { _ in
            let profileEditingViewController = DIContainer.makeProfileEditingViewController(
                initialProfileImageData: self.profileImageView.image?.jpegData(compressionQuality: 1.0),
                initialUserProfile: self.viewModel.userInfo
            )
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
        button.accessibilityIdentifier = "HOME__EDIT_PROFILE"
        return button
    }()
    
    private lazy var userBasicInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private lazy var cvCardStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 30
        $0.isLayoutMarginsRelativeArrangement = true
        let layoutMargin: CGFloat = (deviceWidth - contentWidth) / 2
        $0.layoutMargins.right = layoutMargin
        $0.layoutMargins.left = layoutMargin
    }
    
    private lazy var cardScrollView = UIScrollView().then {
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.alwaysBounceHorizontal = true
        $0.layoutMargins = .zero
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var pageController = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = .black
        $0.backgroundColor = .mainColor
    }
    
    private lazy var addCVButton: AddCVButton = .init().then {
        let action: UIAction = .init { [weak self] _ in
            let cvEditviewController = DIContainer.makeCVEditViewController(editingType: .new)
            self?.navigationController?.pushViewController(cvEditviewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }
    
    // MARK: Initializers
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        bindViewModel()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Override
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.circular()
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
    
    var userInfoBinding: Binder<UserProfile> {
        return .init(self) { viewController, userInfo in
            self.userBasicInfoStackView.removeAllArrangedSubviews()
            
            userInfo.defaultItems.forEach { item in
                let profileInfo: ProfileInfoComponent = .init(userInfoItem: item)
                self.userBasicInfoStackView.addArrangedSubview(profileInfo)
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

                guard let profileImage: UIImage = .init(data: data) else {
                    return
                }
                
                viewController.profileImageView.image = profileImage
            }
        }
    }
    
    var cvsInfoBinding: Binder<[CVInfo]> {
        return .init(self) { vc, cvsInfo in
            
            vc.cvCardStackView.removeAllArrangedSubviews()
            
            cvsInfo.sorted(by: { $0.lastModified > $1.lastModified })
                .forEach { cvInfo in
                    let cvCard = CVCard().then {
                        $0.cvTitleLabel.text = cvInfo.title
                        if let date = ItsMEStandardDateFormatter.date(from: cvInfo.lastModified) {
                            let simpleLastModified = ItsMESimpleDateFormatter.string(from: date)
                            $0.lastModifiedLabel.text = "최근 수정일: " + simpleLastModified
                        } else {
                            $0.lastModifiedLabel.text = "최근 수정일: -"
                        }
                        $0.contextMenuButton.menu = vc.makeContextMenu(with: cvInfo)
                    }
                    vc.cvCardStackView.addArrangedSubview(cvCard)
                    
                    cvCard.snp.makeConstraints { make in
                        make.width.equalTo(vc.contentWidth)
                    }
                    
                    let pushAction: UIAction = .init { _ in
                        let totalCVViewController = DIContainer.makeTotalCVViewController(cvInfo: cvInfo)
                        vc.navigationController?.pushViewController(totalCVViewController, animated: true)
                    }
                    cvCard.addAction(pushAction, for: .touchUpInside)
                }
            
            vc.cvCardStackView.addArrangedSubview(vc.addCVButton)
        }
    }
}

// MARK: - Methods

extension HomeViewController {
    
    private func setupConstraints() {
        self.view.addSubview(profileEditingButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(userBasicInfoStackView)
        cardScrollView.addSubview(cvCardStackView)
        
        self.view.addSubview(cardScrollView)
        self.view.addSubview(pageController)
        
        profileEditingButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.trailing.equalTo(-30)
            make.top.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.4)
            make.centerX.equalToSuperview()
            make.top.equalTo(profileEditingButton.snp.bottom).offset(20)
        }
        
        userBasicInfoStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImageView.snp.bottom).offset(20)
        }
        
        cvCardStackView.snp.makeConstraints { make in
            make.height.left.right.equalToSuperview()
            make.width.greaterThanOrEqualTo(self.view)
        }
        
        cardScrollView.snp.makeConstraints { make in
            make.top.equalTo(userBasicInfoStackView.snp.bottom).offset(30)
            make.bottom.equalToSuperview().inset(30)
            make.width.equalToSuperview()
        }
        
        pageController.snp.makeConstraints { make in
            make.top.equalTo(cardScrollView.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        addCVButton.snp.makeConstraints { make in
            make.width.equalTo(contentWidth)
        }
    }
    
    private func makeContextMenu(with cvInfo: CVInfo) -> UIMenu {
        let editAction: UIAction = .init(
            title: "제목 편집",
            image: UIImage(systemSymbol: .pencilCircleFill),
            handler: { [weak self] _ in
                let cvEditViewController = DIContainer.makeCVEditViewController(editingType: .edit(uuid: cvInfo.uuid, initialCVTitle: cvInfo.title))
                self?.navigationController?.pushViewController(cvEditViewController, animated: true)
            }
        )
        let removeAction: UIAction = .init(
            title: "삭제",
            image: UIImage(systemSymbol: .minusCircleFill),
            attributes: .destructive,
            handler: { [weak self] _ in
                guard let self = self else { return }
                let okAction: UIAlertAction = .init(title: "삭제", style: .destructive) { _ in
                    self.viewModel.removeCV(cvInfo: cvInfo)
                        .emit(onNext: { _ in
                            self.bindViewModel() //FIXME: 추후에 HomeViewModel의 [cvsInfo]에 이벤트를 추가하는 방향으로 개선
                        })
                        .disposed(by: self.disposeBag)
                }
                self.presentConfirmAlert(
                    title: "정말로 삭제하시겠습니까?",
                    message: "소중한 회원님의 정보는 되돌릴 수 없습니다. 이 사실을 인지하고 삭제하시겠습니까?",
                    okAction: okAction
                )
            }
        )
        return UIMenu(
            identifier: UIMenu.Identifier("menuIdetifier"),
            children: [editAction, removeAction]
        )
    }
    
    private func pageOffsets(in scrollView: UIScrollView) -> [CGFloat] {
        let pageWidth = scrollView.bounds.width
        - scrollView.adjustedContentInset.left
        - scrollView.adjustedContentInset.right
        let numberOfPages = Int(ceil(scrollView.contentSize.width / pageWidth))
        let croppedView = 40
        let padding = cvCardStackView.layoutMargins.left
        return (0..<numberOfPages).map { CGFloat(Float($0)) * (padding + CGFloat(contentWidth) - CGFloat(croppedView))}
    }
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let stackViewSpacing: CGFloat = cvCardStackView.spacing
        let stackViewMargin = cvCardStackView.layoutMargins.left
        let contentCount = cvCardStackView.arrangedSubviews.count
        
        let centerCoordinates: [CGFloat] = (0..<contentCount).map { count in
            let count = CGFloat(count)
            return stackViewMargin + contentWidth * count + stackViewSpacing * count + contentWidth / 2
        }
        
        let targetContentCenterOffsetX = targetContentOffset.pointee.x + scrollView.bounds.width / 2
        guard let closestCenterCoordinate = closestValue(targetContentCenterOffsetX, in: centerCoordinates) else {
            return
        }
        
        let destinationOffset = closestCenterCoordinate - (contentWidth / 2) - stackViewMargin
        targetContentOffset.pointee.x = destinationOffset
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
}

// MARK: - for Paging

struct ScrollPageController {
    
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
