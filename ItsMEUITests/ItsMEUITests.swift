//
//  ItsMEUITests.swift
//  ItsMEUITests
//
//  Created by MacBook Air on 2022/11/07.
//

import XCTest

final class ItsMEUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        
        continueAfterFailure = false
        
        addUIInterruptionMonitor(withDescription: "Login Alert") { alert in
            alert.buttons["계속"].tap()
            return true
        }
    }
    
    func test_프로필수정화면_이동() {
        프로필수정화면_이동()
        대기()
    }
    
    func test_학력정보_수정화면_이동() {
        프로필수정화면_이동()
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.tables/*@START_MENU_TOKEN@*/.staticTexts["자연계"]/*[[".cells.staticTexts[\"자연계\"]",".staticTexts[\"자연계\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        대기()
    }
    
    private func 프로필수정화면_이동() {
        app.launch()
        
        app.buttons["kakao login large"].tap()
        app.tap() // 앱 상태 active 로 전환
        
        app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.buttons["계속하기"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=12441\"].webViews.webViews.webViews",".otherElements[\"카카오계정으로 로그인\"].buttons[\"계속하기\"]",".buttons[\"계속하기\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["프로필 수정"]/*[[".buttons[\"프로필 수정\"].staticTexts[\"프로필 수정\"]",".staticTexts[\"프로필 수정\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    private func 대기() {
        _ = app.wait(for: .notRunning, timeout: .infinity)
    }
}
