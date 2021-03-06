// MiscellaneousTests.swift
//
// Copyright (C) 2016 Subito.it S.r.l (www.subito.it)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SBTUITestTunnel
import Foundation

class MiscellaneousTests: XCTestCase {
    
    var app: SBTUITunneledApplication = SBTUITunneledApplication()
    
    func testStartupCommands() {
        let keychainKey = "test_kc_key"
        let randomString = ProcessInfo.processInfo.globallyUniqueString
        app.launchTunnel() {
            self.app.keychainSetObject(randomString as NSCoding & NSObjectProtocol, forKey: keychainKey)
            self.app.setUserInterfaceAnimationsEnabled(false)
        }
        
        XCTAssertEqual(randomString, app.keychainObject(forKey: keychainKey) as! String)
    }
    
    func testCustomCommand() {
        app.launchTunnel(withOptions: [SBTUITunneledApplicationLaunchOptionResetFilesystem])
        
        let randomString = ProcessInfo.processInfo.globallyUniqueString
        let retObj = app.performCustomCommandNamed("myCustomCommandReturnNil", object: NSString(string: randomString))
        let randomStringRemote = app.userDefaultsObject(forKey: "custom_command_test") as! String
        XCTAssertEqual(randomString, randomStringRemote)
        XCTAssertNil(retObj)
        
        let randomString2 = ProcessInfo.processInfo.globallyUniqueString
        let retObj2 = app.performCustomCommandNamed("myCustomCommandReturn123", object: NSString(string: randomString2))
        let randomStringRemote2 = app.userDefaultsObject(forKey: "custom_command_test") as! String
        XCTAssertEqual(randomString2, randomStringRemote2)
        XCTAssertEqual("123", retObj2 as! String)
        
        let retObj3 = app.performCustomCommandNamed("myCustomCommandReturn123", object: nil)
        XCTAssertNil(app.userDefaultsObject(forKey: "custom_command_test"))
        XCTAssertEqual("123", retObj3 as! String)
    }
    
    func testAutocompleteEnabled() {
        app.launchTunnel(withOptions: [SBTUITunneledApplicationLaunchOptionResetFilesystem])
        
        let text = "Tesling things" // Telling things
        
        app.cells["showAutocompleteForm"].tap()
        
        let textField = app.textFields.element(boundBy: 0)
        textField.tap()
        app.typeText(text)
        
        Thread.sleep(forTimeInterval: 1.0)
        let textFieldText = textField.value as? String
        
        XCTAssertNotEqual(text, textFieldText)
    }

    func testAutocompleteDisabled() {
        app.launchTunnel(withOptions: [SBTUITunneledApplicationLaunchOptionResetFilesystem, SBTUITunneledApplicationLaunchOptionDisableUITextFieldAutocomplete])
        
        let text = "Tesling things" // Telling things
        
        app.cells["showAutocompleteForm"].tap()

        let textField = app.textFields.element(boundBy: 0)
        textField.tap()
        app.typeText(text)
        
        Thread.sleep(forTimeInterval: 1.0)
        let textFieldText = textField.value as? String
        
        XCTAssertEqual(text, textFieldText)
    } 
}
