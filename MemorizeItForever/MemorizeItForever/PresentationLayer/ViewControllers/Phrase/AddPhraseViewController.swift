//
//  AddPhraseViewController.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 11/8/16.
//  Copyright © 2016 SomeSimpleSolutions. All rights reserved.
//

import UIKit
import MemorizeItForeverCore

final class AddPhraseViewController: VFLBasedViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: Controls
    
    var desc: UILabel!
    var phrase: MITextView!
    var meaning: MITextView!
    
    // MARK: Field injection
    
    var validator: ValidatorProtocol?
    var wordManager: WordManagerProtocol?
    
    // MARK: Local variables
    
    var doneBarButtonItem: UIBarButtonItem!
    var nextBarButtonItem: UIBarButtonItem!
    var saveBarButtonItem: UIBarButtonItem!
    var previousBarButtonItem: UIBarButtonItem!
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Phrase"
        
        doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddPhraseViewController.doneBarButtonTapHandler))
        nextBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(AddPhraseViewController.nextBarButtonTapHandler))
        saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddPhraseViewController.saveBarButtonTapHandler))
        previousBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(AddPhraseViewController.previousBarButtonTapHandler))
        
        self.navigationItem.leftBarButtonItem = doneBarButtonItem
        self.navigationItem.rightBarButtonItem = nextBarButtonItem
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func defineControls(){
        desc = MILabel()
        desc.text = "Write the Phrase here"
        
        phrase = MITextView()
        phrase.font = phrase.font?.withSize(20)
        phrase.alpha = 0.7
        
        meaning = MITextView()
        meaning.isHidden = true
        meaning.font = meaning.font?.withSize(20)
        meaning.alpha = 0.7
    }
    
    override func addControls(){
        self.view.addSubview(desc)
        self.view.addSubview(phrase)
        self.view.addSubview(meaning)
    }
    
    override func applyAutoLayout(){
        var constraintList: [NSLayoutConstraint] = []
        
        viewDic["desc"] = desc
        viewDic["phrase"] = phrase
        viewDic["meaning"] = meaning
        
        let hDescCnst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[desc]", options: [], metrics: nil, views: viewDic)
        let vDescCnst = NSLayoutConstraint.constraints(withVisualFormat: "V:[topLayoutGuide]-[desc(21.5)]-[phrase]-30-[bottomLayoutGuide]", options: [], metrics: nil, views: viewDic)
        
        let hPhraseCnst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[phrase]-|", options: [], metrics: nil, views: viewDic)
        
        let hMeaningCnst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[meaning]-|", options: [], metrics: nil, views: viewDic)
        
        
        constraintList += hDescCnst
        constraintList += vDescCnst
        constraintList += hPhraseCnst
        constraintList += hMeaningCnst
        
        let meaningTopCnst = NSLayoutConstraint(item: meaning, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: phrase, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let meaningBottomCnst = NSLayoutConstraint(item: meaning, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: phrase, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        constraintList.append(meaningTopCnst)
        constraintList.append(meaningBottomCnst)
        
        NSLayoutConstraint.activate(constraintList)
    }
    
     // MARK: Internal methods
    
    func doneBarButtonTapHandler(){
        guard let validator = validator else {
            fatalError("validator is not initialized ")
        }
        
        validator.clear(validatable: phrase)
        self.dismiss(animated: true, completion: nil)
    }
    
    func nextBarButtonTapHandler(){
        guard let validator = validator else {
            fatalError("validator is not initialized ")
        }
        
        let result = validator.validate(phrase, errorMessage: "Phrase should not be empty") {
            !($0 as! MITextView).text.trim().isEmpty
        }
        
        if result{
            
            updateDesctext(showPhrase: false)
            
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
            self.navigationItem.leftBarButtonItem = previousBarButtonItem
            
            UIView.transition(from: phrase, to: meaning, duration: 1, options: [.transitionFlipFromRight ,.showHideTransitionViews], completion: nil)
        }
    }
    
    func saveBarButtonTapHandler(){
        guard let validator = validator else {
            fatalError("validator is not initialized ")
        }
        guard let wordManager = wordManager else {
            fatalError("wordManager is not initialized ")
        }
        
        let result = validator.validate(meaning, errorMessage: "Meaning should not be empty") {
            !($0 as! MITextView).text.trim().isEmpty
        }
        
        if result{
            
        }
    }
    
    func previousBarButtonTapHandler(){
        guard let validator = validator else {
            fatalError("validator is not initialized ")
        }
        
        validator.clear(validatable: meaning)
        
        updateDesctext(showPhrase: true)
        
        self.navigationItem.rightBarButtonItem = nextBarButtonItem
        self.navigationItem.leftBarButtonItem = doneBarButtonItem
        
        UIView.transition(from: meaning, to: phrase , duration: 1, options: [.transitionFlipFromLeft ,.showHideTransitionViews], completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: Private methods
    
    private func updateDesctext(showPhrase: Bool){
        if showPhrase{
            desc.text = "Write the Phrase here"
        }
        else{
            desc.text = "Write the Meaning here"
        }
    }
}
