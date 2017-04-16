//
//  DetailViewController.swift
//  NEW_NOTES_SWIFT3_FIREBASE
//
//  Created by GOD on 3/24/17.
//  Copyright © 2017 ALL ONE SUN. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var textView: UITextView!
var text:String = ""
var masterView:ViewController!

    
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    textView.text = text
    textView.becomeFirstResponder()
}

func setText(t:String) {
    text = t
    if isViewLoaded {
        textView.text = t
    }
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    masterView.newRowText = textView.text
    
    //Save the data to fb database if the text field is not blank
    if (textView.text=="") {
        masterView.ref.child("NOTES_APP_DATA").child(String(masterView.selectedRow)).setValue("THAT WAS BLANK")
    }
    else
    {
        
        masterView.ref.child("NOTES_APP_DATA").child(textView.text).setValue(textView.text)
        
        
    }
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
