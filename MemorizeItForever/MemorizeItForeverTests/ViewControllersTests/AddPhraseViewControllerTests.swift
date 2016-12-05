//
//  AddNewPhraseViewControllerTests.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 11/8/16.
//  Copyright © 2016 SomeSimpleSolutions. All rights reserved.
//

import XCTest
import MemorizeItForeverCore
@testable import MemorizeItForever

class AddPhraseViewControllerTests: XCTestCase {
    
    var wordManager: WordManagerProtocol!
    var addPhraseViewController: AddPhraseViewController!
    
    override func setUp() {
        super.setUp()
        var setModel = SetModel()
        setModel.setId = UUID()
        setModel.name = "Default"
        UserDefaults.standard.set(setModel.toDic(), forKey:  Settings.defaultSet.rawValue)
        wordManager = MockWordManager()
        addPhraseViewController = AddPhraseViewController()
        addPhraseViewController.wordManager = wordManager
        _ = addPhraseViewController.view
    }
    
    override func tearDown() {
        wordManager = nil
        objc_removeAssociatedObjects(addPhraseViewController)
        addPhraseViewController = nil
        super.tearDown()
    }
    
    func testAddPhraseViewControllerHasTitle(){
        addPhraseViewController.viewDidLoad()
        XCTAssertEqual(addPhraseViewController.title,"Add Phrase","AddPhraseViewController should have a title")
    }
    
    func testHasDoneBarButton() {
        addPhraseViewController.viewDidLoad()
        let doneBarButton = addPhraseViewController.navigationItem.leftBarButtonItem
        XCTAssertEqual(doneBarButton?.title, "Close","View controller should have a left bar button titled 'Done'")
    }
    
    func testDoneBarButtonTapHandled() {
        
        let originalSelector = #selector(AddPhraseViewController.doneBarButtonTapHandler)
        let swizzledSelector = #selector(AddPhraseViewController.mockDoneBarButtonTapHandler)
        
        Helper.methodSwizzling(AddPhraseViewController.self, origin: originalSelector, swizzled: swizzledSelector)
        
        addPhraseViewController.viewDidLoad()
        let doneBarButton = addPhraseViewController.navigationItem.leftBarButtonItem
        UIApplication.shared.sendAction(doneBarButton!.action!, to: doneBarButton!.target, from: self, for: nil)
        let result = objc_getAssociatedObject(addPhraseViewController, &key) as? AddPhraseViewControllerEnum
        XCTAssertEqual(result, .doneBarButtonTap,"should handle done bar button item tap")
    }
    
    func testHasNextBarButton() {
        addPhraseViewController.viewDidLoad()
        let nextBarButton = addPhraseViewController.navigationItem.rightBarButtonItem
        XCTAssertEqual(nextBarButton?.title, "Next","View controller should have a left bar button titled 'Done'")
    }
    
    func testNextBarButtonTapHandled() {
        
        let originalSelector = #selector(AddPhraseViewController.nextBarButtonTapHandler)
        let swizzledSelector = #selector(AddPhraseViewController.mockNextBarButtonTapHandler)
        
        Helper.methodSwizzling(AddPhraseViewController.self, origin: originalSelector, swizzled: swizzledSelector)
        
        addPhraseViewController.viewDidLoad()
        let nextBarButton = addPhraseViewController.navigationItem.rightBarButtonItem
        UIApplication.shared.sendAction(nextBarButton!.action!, to: nextBarButton!.target, from: self, for: nil)
        let result = objc_getAssociatedObject(addPhraseViewController, &key) as? AddPhraseViewControllerEnum
        XCTAssertEqual(result, .nextBarButtonTap,"should handle next bar button item tap")
    }
    
    func testHasLabelDesc() {
        addPhraseViewController.viewDidLoad()
        XCTAssertEqual(addPhraseViewController.desc.text, "Write the Phrase here","View controller should have a label description")
    }
    
    func testHasPharseTextView() {
        addPhraseViewController.viewDidLoad()
        addPhraseViewController.phrase.text = "Livre"
        XCTAssertEqual(addPhraseViewController.phrase.text, "Livre","View controller should have a phrase text view")
    }
    
    func testHasMeaningTextView() {
        addPhraseViewController.viewDidLoad()
        addPhraseViewController.meaning.text = "Book"
        XCTAssertEqual(addPhraseViewController.meaning.text, "Book","View controller should have a meaning text view")
    }
    
    func testApplyErrorWhenNextBarButtonTappedIfPhraseIsEmpty() {
        addPhraseViewController.viewDidLoad()
        addPhraseViewController.validator = MockValidator()
        addPhraseViewController.nextBarButtonTapHandler()
        XCTAssertEqual(addPhraseViewController.phrase.layer.borderColor, UIColor.red.cgColor,"should apply error if phrase is empty when tapped next button")
    }

    func testGoNextLevelWhenNextBarButtonTappedIfPhraseIsNotEmpty() {
        addPhraseViewController.viewDidLoad()
        addPhraseViewController.phrase.text = "Livre"
        addPhraseViewController.validator = MockValidator()
        addPhraseViewController.nextBarButtonTapHandler()
        XCTAssertEqual(addPhraseViewController.phrase.layer.borderColor, UIColor.lightGray.cgColor,"should clear error if phrase is not empty when tapped next button")
        XCTAssertTrue(addPhraseViewController.phrase.isHidden,"should phrase hide if phrase is not empty when tapped next button")
        XCTAssertFalse(addPhraseViewController.meaning.isHidden,"should meaning show if phrase is not empty when tapped next button")
        XCTAssertEqual(addPhraseViewController.desc.text, "Write the Meaning here", "should label has the appropiate text if phrase is not empty when tapped next button")
     
        let saveBarButton = addPhraseViewController.navigationItem.rightBarButtonItem
        XCTAssertEqual(saveBarButton?.title, "Save", "should rightBarButtonItem change to save if phrase is not empty when tapped next button")
        
        let previousBarButton = addPhraseViewController.navigationItem.leftBarButtonItem
        XCTAssertEqual(previousBarButton?.title, "Previous", "should leftBarButtonItem change to previous if phrase is not empty when tapped next button")
    }
    
    func testSaveBarButtonTapHandled() {
        
        let originalSelector = #selector(AddPhraseViewController.saveBarButtonTapHandler)
        let swizzledSelector = #selector(AddPhraseViewController.mockSaveBarButtonTapHandler)
        
        Helper.methodSwizzling(AddPhraseViewController.self, origin: originalSelector, swizzled: swizzledSelector)
        
        addPhraseViewController.viewDidLoad()
        let saveBarButton = addPhraseViewController.saveBarButtonItem
        UIApplication.shared.sendAction(saveBarButton!.action!, to: saveBarButton!.target, from: self, for: nil)
        let result = objc_getAssociatedObject(addPhraseViewController, &key) as? AddPhraseViewControllerEnum
        XCTAssertEqual(result, .saveBarButtonTap,"should handle save bar button item tap")
    }
    
    func testPreviousBarButtonTapHandled() {
        
        let originalSelector = #selector(AddPhraseViewController.previousBarButtonTapHandler)
        let swizzledSelector = #selector(AddPhraseViewController.mockPreviousBarButtonTapHandler)
        
        Helper.methodSwizzling(AddPhraseViewController.self, origin: originalSelector, swizzled: swizzledSelector)
        
        addPhraseViewController.viewDidLoad()
        let previousBarButton = addPhraseViewController.previousBarButtonItem
        UIApplication.shared.sendAction(previousBarButton!.action!, to: previousBarButton!.target, from: self, for: nil)
        let result = objc_getAssociatedObject(addPhraseViewController, &key) as? AddPhraseViewControllerEnum
        XCTAssertEqual(result, .previousBarButtonTap,"should handle previous bar button item tap")
    }
    
    
    func testGoPreviousLevelWhenPreviousBarButtonTapped() {
         addPhraseViewController.validator = MockValidator()
         addPhraseViewController.previousBarButtonTapHandler()
        
        XCTAssertFalse(addPhraseViewController.phrase.isHidden,"should phrase hide when tapped previous button")
        XCTAssertTrue(addPhraseViewController.meaning.isHidden,"should meaning show when tapped prebious button")
        XCTAssertEqual(addPhraseViewController.desc.text, "Write the Phrase here", "should label has the appropiate text when tapped previous button")
        
        let nextBarButton = addPhraseViewController.navigationItem.rightBarButtonItem
        XCTAssertEqual(nextBarButton?.title, "Next", "should rightBarButtonItem change to next when tapped previous button")
        
        let doneBarButton = addPhraseViewController.navigationItem.leftBarButtonItem
        XCTAssertEqual(doneBarButton?.title, "Close", "should leftBarButtonItem change to done when tapped previous button")
    }
    
    func testApplyErrorWhenSaveBarButtonTappedIfMeaningIsEmpty() {
        addPhraseViewController.validator = MockValidator()
 addPhraseViewController.saveBarButtonTapHandler()
        XCTAssertEqual(addPhraseViewController.meaning.layer.borderColor, UIColor.red.cgColor,"should apply error if meaning is empty when tapped save button")
    }
    
    func testSaveWhenSaveBarButtonTappedIfMeaningIsNotEmpty() {
        addPhraseViewController.meaning.text = "Book"
        addPhraseViewController.validator = MockValidator()
        addPhraseViewController.saveBarButtonTapHandler()
        let result = objc_getAssociatedObject(wordManager, &key) as? AddPhraseViewControllerEnum
        XCTAssertEqual(result, .saveWord,"should call save method on wordManager")
    }
    
    func testIfSaveWasSuccessfulMakeASuccessToastAndClearTheForm() {
        let originalSelector = #selector(UIView.makeASuccessToast)
        let swizzledSelector = #selector(UIView.mockMakeASuccessToast)
        
        Helper.methodSwizzling(UIView.self, origin: originalSelector, swizzled: swizzledSelector)
        
        addPhraseViewController.validator = MockValidator()
        addPhraseViewController.meaning.text = "Book"
        addPhraseViewController.saveBarButtonTapHandler()

        
        XCTAssertFalse(addPhraseViewController.phrase.isHidden,"should phrase hide when tapped previous button")
        XCTAssertTrue(addPhraseViewController.meaning.isHidden,"should meaning show when tapped prebious button")
        XCTAssertEqual(addPhraseViewController.desc.text, "Write the Phrase here", "should label has the appropiate text when tapped previous button")
        
        let nextBarButton = addPhraseViewController.navigationItem.rightBarButtonItem
        XCTAssertEqual(nextBarButton?.title, "Next", "should rightBarButtonItem change to next when tapped previous button")
        
        let doneBarButton = addPhraseViewController.navigationItem.leftBarButtonItem
        XCTAssertEqual(doneBarButton?.title, "Close", "should leftBarButtonItem change to done when tapped previous button")
        
        XCTAssertTrue(addPhraseViewController.phrase.text.isEmpty,"Should clear the phrase")
        
        XCTAssertTrue(addPhraseViewController.meaning.text.isEmpty,"Should clear the meaning")
        
        let result = objc_getAssociatedObject(addPhraseViewController.view, &key) as? UIViewEnum
        XCTAssertEqual(result, .successToast,"should make a success toast when save was successful")
    }
    
    func testIfSaveWasUnsuccessfulMakeAFailureToastAndPreserveForm() {
        let originalSelector = #selector(UIView.makeAFailureToast)
        let swizzledSelector = #selector(UIView.mockMakeAFailureToast)
        
        Helper.methodSwizzling(UIView.self, origin: originalSelector, swizzled: swizzledSelector)
        
        UserDefaults.standard.set(nil, forKey:  Settings.defaultSet.rawValue)
        
        addPhraseViewController.phrase.text = "Livre"
        addPhraseViewController.validator = MockValidator()
        addPhraseViewController.nextBarButtonTapHandler()
        addPhraseViewController.meaning.text = "Book"
        addPhraseViewController.saveBarButtonTapHandler()
        
        XCTAssertTrue(addPhraseViewController.phrase.isHidden,"should phrase hide if phrase is not empty when tapped next button")
        XCTAssertFalse(addPhraseViewController.meaning.isHidden,"should meaning show if phrase is not empty when tapped next button")
        XCTAssertEqual(addPhraseViewController.desc.text, "Write the Meaning here", "should label has the appropiate text if phrase is not empty when tapped next button")
        
        let rightBarButtonItem = addPhraseViewController.navigationItem.rightBarButtonItem
        XCTAssertEqual(rightBarButtonItem?.title, "Save", "should rightBarButtonItem change to save if phrase is not empty when tapped next button")
        
        let previousBarButton = addPhraseViewController.navigationItem.leftBarButtonItem
        XCTAssertEqual(previousBarButton?.title, "Previous", "should leftBarButtonItem change to previous if phrase is not empty when tapped next button")
        
        let result = objc_getAssociatedObject(addPhraseViewController.view, &key) as? UIViewEnum
        XCTAssertEqual(result, .failureToast,"should make a success toast when save was successful")
    }
}

extension AddPhraseViewController{
    func mockDoneBarButtonTapHandler(){
        objc_setAssociatedObject(self, &key, AddPhraseViewControllerEnum.doneBarButtonTap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func mockNextBarButtonTapHandler(){
        objc_setAssociatedObject(self, &key, AddPhraseViewControllerEnum.nextBarButtonTap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func mockSaveBarButtonTapHandler(){
        objc_setAssociatedObject(self, &key, AddPhraseViewControllerEnum.saveBarButtonTap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func mockPreviousBarButtonTapHandler(){
        objc_setAssociatedObject(self, &key, AddPhraseViewControllerEnum.previousBarButtonTap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
