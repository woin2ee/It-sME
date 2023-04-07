//
//  IconInputCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import RxSwift
import RxCocoa
import SnapKit
import Then
import UIKit

final class IconInputCell: UITableViewCell {
    
    // MARK: UI Objects
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.text = "아이콘"
    }
    private lazy var iconLabel: UILabel = .init()
    private lazy var iconSelectButton: UIButton = .init().then {
        $0.setImage(.init(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .systemGray
        $0.addAction(UIAction(handler: { [weak self] _ in
            self?.toggleIconPickerView()
        }), for: .touchUpInside)
    }
    private(set) lazy var iconPickerView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.iconCellSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.layer.cornerRadius = 10.0
        collectionView.clipsToBounds = true
        collectionView.layer.shadowColor = UIColor.systemGray.cgColor
        collectionView.layer.shadowRadius = 60.0
        collectionView.layer.shadowOffset = .zero
        collectionView.layer.shadowOpacity = 0.5
        collectionView.layer.masksToBounds = false
        return collectionView
    }()
    
    // MARK: Properties
    
    var icon: UserInfoItemIcon = .default {
        willSet {
            iconLabel.text = newValue.toEmoji
        }
    }
    
    /// 해당 값을 직접 변경하는건 권장하지 않습니다.
    private var isShowingIconPickerView: Bool = false {
        willSet {
            if isShowingIconPickerView {
                self.hideIconPickerView()
            } else {
                self.showIconPickerView()
            }
        }
    }
    private var isAnimating: Bool = false
    private let iconCellSize: CGSize = .init(width: 50, height: 50)
    private let itemCountPerLine = 4
    private var itemLineCount: Int { (UserInfoItemIcon.allCases.count + itemCountPerLine) / itemCountPerLine }
    private let animationDuration: TimeInterval = 0.5
    private let dampingRatio: CGFloat = 0.8
    private let initialSpringVelocity: CGFloat = 0.3
    
    // MARK: Initializers
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        self.backgroundColor = .secondarySystemGroupedBackground
        self.selectionStyle = .none
        addTapGesture()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}

// MARK: - Private Methods

private extension IconInputCell {
    
    func configureSubviews() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40).priority(999)
            make.width.equalTo(60)
        }
        
        self.contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
        
        self.contentView.addSubview(iconSelectButton)
        iconSelectButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(40)
            make.leading.equalTo(iconLabel.snp.trailing)
        }
    }
    
    @objc func toggleIconPickerView() {
        if !isAnimating {
            isShowingIconPickerView.toggle()
        }
    }
    
    /// 애니메이션 효과와 함께 `IconPickerView` 를 화면에 나타냅니다.
    ///
    /// 이 함수를 직접 호출하는건 권장하지 않습니다. 대신 `toggleIconPickerView()` 를 이용하세요.
    func showIconPickerView() {
        guard let window = self.window else { return }
        
        window.addSubview(iconPickerView)
        iconPickerView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.bottom).offset(-2)
            make.trailing.equalTo(self.contentView).offset(-8)
            make.size.equalToZero()
        }
        window.layoutIfNeeded()
        
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: initialSpringVelocity,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: { [self] in
                iconPickerView.snp.updateConstraints { make in
                    make.width.equalTo(iconCellSize.width * CGFloat(itemCountPerLine))
                    make.height.equalTo(iconCellSize.height * CGFloat(itemLineCount))
                }
                window.layoutIfNeeded()
            }
        )
    }
    
    /// 애니메이션 효과와 함께 `IconPickerView` 를 화면에서 사라지게 합니다.
    ///
    /// 이 함수를 직접 호출하는건 권장하지 않습니다. 대신 `toggleIconPickerView()` 를 이용하세요.
    func hideIconPickerView() {
        isAnimating = true
        
        guard let window = self.window else { return }
        
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: initialSpringVelocity,
            options: .curveEaseOut,
            animations: {
                self.iconPickerView.snp.updateConstraints { make in
                    make.size.equalToZero()
                }
                window.layoutIfNeeded()
            },
            completion: { _ in
                self.iconPickerView.snp.removeConstraints()
                self.iconPickerView.removeFromSuperview()
                self.isAnimating = false
            }
        )
    }
    
    func addTapGesture() {
        let tapGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(toggleIconPickerView))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - UICollectionViewDataSource

extension IconInputCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserInfoItemIcon.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.reuseIdentifier, for: indexPath) as! IconCell
        cell.icon = UserInfoItemIcon.allCases[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension IconInputCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIcon = UserInfoItemIcon.allCases[indexPath.row]
        self.icon = selectedIcon
        hideIconPickerView()
    }
}

// MARK: - Reactive Extension

extension Reactive where Base: IconInputCell {
    
    private var delegateProxy: DelegateProxy<IconInputCell, UICollectionViewDelegate> {
        return IconInputCellDelegateProxy.proxy(for: self.base)
    }
    
    var icon: ControlEvent<UserInfoItemIcon> {
        let source = delegateProxy
            .methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { parameters -> UserInfoItemIcon in
                guard let indexPath = parameters[1] as? IndexPath else {
                    preconditionFailure("Delegate 함수의 파라미터 타입이 일치하지 않습니다.")
                }
                return UserInfoItemIcon.allCases[indexPath.row]
            }
        return .init(events: source)
    }
}

final class IconInputCellDelegateProxy:
    DelegateProxy<IconInputCell, UICollectionViewDelegate>,
    DelegateProxyType,
    UICollectionViewDelegate
{
    static func registerKnownImplementations() {
        self.register { parant in
            return .init(parentObject: parant, delegateProxy: IconInputCellDelegateProxy.self)
        }
    }
    
    static func currentDelegate(for object: IconInputCell) -> UICollectionViewDelegate? {
        return object.iconPickerView.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UICollectionViewDelegate?, to object: IconInputCell) {
        object.iconPickerView.delegate = delegate
    }
}
