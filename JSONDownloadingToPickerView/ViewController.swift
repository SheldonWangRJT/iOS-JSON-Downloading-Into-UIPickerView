//
//  ViewController.swift
//  JSONDownloadingToPickerView
//
//  Created by Xiaodan Wang on 7/3/17.
//  Copyright © 2017 Xiaodan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private var seletionsArray = [String]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resLabel: UILabel!
    @IBOutlet weak var activity1: UIActivityIndicatorView!
    @IBOutlet weak var activity2: UIActivityIndicatorView!
    
    @IBAction func ShowDOW(_ sender: Any) {
        
        let urlString = "http://localhost:3000/DayOfWeek"
        let url = URL(string: urlString)
        
        guard let validUrl = url else { return }
        
        activity1.isHidden = false
        WebManager.downloadJson(from: validUrl) { (resArray) in
            self.activity1.isHidden = true
            
            self.seletionsArray = resArray
            
            self.pickerView.dataSource = self
            self.pickerView.delegate = self
            
            self.animateShowingPickerView()
        }
    }
    
    @IBAction func showLocation(_ sender: Any) {
        let urlString = "http://localhost:3000/Location"
        let url = URL(string: urlString)
        
        guard let validUrl = url else { return }
        
        activity2.isHidden = false
        WebManager.downloadJson(from: validUrl) { (resArray) in
            self.activity2.isHidden = true
            
            self.seletionsArray = resArray
            
            self.pickerView.dataSource = self
            self.pickerView.delegate = self
            
            self.animateShowingPickerView()
        }
    }
    
    @IBAction func selet(_ sender: Any) {
        resLabel.text =  seletionsArray[pickerView.selectedRow(inComponent: 0)]
        
        animateHidingPickerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity1.isHidden = true
        activity2.isHidden = true
        activity1.startAnimating()
        activity2.startAnimating()
        
        containerView.alpha = 0
    }

    //MARK: - picker view dele & datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return seletionsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seletionsArray[row]
    }
    
    //MARK: - animation
    func animateHidingPickerView() {
        UIView.animate(withDuration: 1) {
            self.containerView.alpha = 0
        }
    }
    
    func animateShowingPickerView() {
        UIView.animate(withDuration: 1) {
            self.containerView.alpha = 1
        }
    }
}


//webservice class
class WebManager {
    
    class func downloadJson(from url:URL, completion:@escaping ([String])->Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion([])
                }else {
                    guard let data = data else {
                        completion([])
                        return
                    }
                    let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    
                    guard let resArray = obj as? [String] else {
                        completion([])
                        return
                    }
                    completion(resArray)
                }
            }
        }.resume()
    }
}


