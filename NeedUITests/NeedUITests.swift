//
//  NeedUITests.swift
//  NeedUITests
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import XCTest
@testable import SwiftMonkey

class NeedUITests: XCTestCase {

     override func setUp() {
           super.setUp()
           XCUIApplication().launch()
       }
       
       override func tearDown() {
           super.tearDown()
       }
       
       func testMonkey() {
           let application = XCUIApplication()

           // Initialise the monkey tester with the current device
           // frame. Giving an explicit seed will make it generate
           // the same sequence of events on each run, and leaving it
           // out will generate a new sequence on each run.
           let monkey = Monkey(frame: application.frame)
           //let monkey = Monkey(seed: 123, frame: application.frame)

           // Add actions for the monkey to perform. We just use a
           // default set of actions for this, which is usually enough.
           // Use either one of these but maybe not both.
           
           // XCTest private actions seem to work better at the moment.
           // before Xcode 10.1, you can use
           // monkey.addDefaultXCTestPrivateActions()
           
           // after Xcode 10.1 We can only use public API
//           monkey.addDefaultUIAutomationActions()

           monkey.addUIAutomationTapAction(weight: 50)
           monkey.addUIAutomationDragAction(weight: 1)
           monkey.addUIAutomationFlickAction(weight: 1)
           monkey.addUIAutomationPinchCloseAction(weight: 1)
           monkey.addUIAutomationPinchOpenAction(weight: 1)
           //addUIAutomationRotateAction(weight: 1) // TODO: Investigate why this is broken.
//           monkey.addUIAutomationOrientationAction(weight: 1)
//           monkey.addUIAutomationClickVolumeUpAction(weight: 1)
//           monkey.addUIAutomationClickVolumeDownAction(weight: 1)
//           monkey.addUIAutomationShakeAction(weight: 1)
//           monkey.addUIAutomationLockAction(weight: 1)
        
           // UIAutomation actions seem to work only on the simulator.
           //monkey.addDefaultUIAutomationActions()
           
           // Occasionally, use the regular XCTest functionality
           // to check if an alert is shown, and click a random
           // button on it.
           monkey.addXCTestTapAlertAction(interval: 100, application: application)

           // Run the monkey test indefinitely.
           monkey.monkeyAround()
       }
    
}
