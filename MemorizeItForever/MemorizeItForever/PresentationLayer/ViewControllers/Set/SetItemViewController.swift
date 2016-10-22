//
//  SetItemViewController.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 9/2/16.
//  Copyright © 2016 SomeSimpleSolution. All rights reserved.
//

import UIKit
import MemorizeItForeverCore

final class SetItemViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    private var setName: UITextField!
    
    var entityMode: EntityMode?
    var setModel: SetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SetItemViewController.saveAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SetItemViewController.cancelAction))
        
        self.view.backgroundColor = UIColor.white
        
        setName = UITextField()
        setName.translatesAutoresizingMaskIntoConstraints = false
        setName.becomeFirstResponder()
        
        self.view.addSubview(setName)
        
        let views: Dictionary<String, AnyObject> = ["setName": setName,
                     "topLayoutGuide": topLayoutGuide]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let hSetNameCnst = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[setName]-|",
            options: [],
            metrics: nil,
            views: views)
        
        let vSetNameCnst = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayoutGuide]-50-[setName]",
            options: [],
            metrics: nil,
            views: views)
        
        
        allConstraints += hSetNameCnst
        allConstraints += vSetNameCnst
        
        NSLayoutConstraint.activate(allConstraints)
        
        if let setModel = setModel , entityMode == .edit{
            DispatchQueue.main.async(execute: {
                self.setName.text = setModel.name
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func saveAction(){
        if entityMode == .save{
            save()
        }
        else{
            edit()
        }
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.postNotification(.setViewControllerReload, object: nil)
    }
    
    func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func save(){
        SetManager().save(setName.text!)
    }
    
    func edit(){
        SetManager().edit(setModel!, setName: setName.text!)
    }
}
