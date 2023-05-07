//
//  ProfileEditingViewModelTests.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/08.
//

@testable import ItsME
import RxSwift
import XCTest

final class ProfileEditingViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    var sut: ProfileEditingViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
//        sut = .init(initalProfileImageData: <#T##Data?#>, userInfo: <#T##UserProfile#>)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        disposeBag = nil
        sut = nil
    }
    
    func test() {
        
    }
}
