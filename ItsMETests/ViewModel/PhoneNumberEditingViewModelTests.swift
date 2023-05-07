//
//  PhoneNumberEditingViewModelTests.swift
//  ItsMENoneHostAppTests
//
//  Created by Jaewon Yun on 2023/05/07.
//

@testable import ItsME
import RxBlocking
import RxSwift
import XCTest

final class PhoneNumberEditingViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var mockDelegate: MockDelegate!
    
    var sut: PhoneNumberEditingViewModel!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = .init()
        mockDelegate = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        
        disposeBag = nil
        mockDelegate = nil
        sut = nil
    }
    
    // 초기 전화번호를 주입했을때 output 으로 나오는지 테스트
    func test_transformInitialPhoneNumberToOutput() {
        // Arrange
        let initialPhoneNumber = "010-1234-5678"
        sut = .init(initialPhoneNumber: initialPhoneNumber, delegate: mockDelegate)
        let input: PhoneNumberEditingViewModel.Input = .init(phoneNumber: .never(), saveTrigger: .never())
        let output = sut.transform(input: input)
        
        // Act
        let currentPhoneNumber = try? output.phoneNumber.toBlocking().first()
        
        // Assert
        XCTAssertEqual(initialPhoneNumber, currentPhoneNumber)
    }
    
    // saveTrigger input 이 발생했을때 delegate 함수 호출과 output 으로 변환 테스트
    func test_callDelegateAndTransformToOutputOnSaveTrigger() {
        // Arrange
        let saveTrigger: PublishSubject<Void> = .init()
        sut = .init(initialPhoneNumber: "", delegate: mockDelegate)
        let input: PhoneNumberEditingViewModel.Input = .init(phoneNumber: .never(), saveTrigger: saveTrigger.asSignalOnErrorJustComplete())
        let output = sut.transform(input: input)
        var saveComplete: Bool = false
        
        // Act
        output.saveComplete
            .doOnNext { saveComplete = true }
            .emit()
            .disposed(by: disposeBag)
        saveTrigger.onNext(())
        
        // Assert
        XCTAssertEqual(mockDelegate.didCalledDelegateMethod, 1)
        XCTAssertTrue(saveComplete)
    }
}
