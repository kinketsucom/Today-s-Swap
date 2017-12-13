//
//  ViewController.swift
//  Todays_Swap
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 sekibotbot. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Fuzi

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var BuySwapLabel: UILabel!
    @IBOutlet weak var SellSwapLabel: UILabel!
    @IBOutlet weak var AddDateLabel: UILabel!
    
    @IBOutlet weak var SumMoneyLabel: UILabel!
    
    @IBOutlet weak var MyPickerView: UIPickerView!
    
    
    let list = ["10000", "20000", "30000", "40000", "50000"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let kendama = Float64(list[row])!/100.0
        SumMoneyLabel.text = String(kendama*Float64(BuySwapLabel.text!)!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyPickerView.delegate = self
        MyPickerView.dataSource = self
        BuySwapLabel.text = "0"
        SellSwapLabel.text = "0"
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request("https://www.moneypartners.co.jp/market/swap/nano/", method: .get).responseString(completionHandler: {response in
            // ここに処理を記述していく
//            print(response)
            let html = response.value!
            do {
                // if encoding is omitted, it defaults to NSUTF8StringEncoding
                let doc = try HTMLDocument(string: html, encoding: String.Encoding.utf8)
                
                // CSS queries
                if let elementById = doc.firstChild(css: "#area0") {
//                    print(elementById)
//                    print("****************************")
                    if let elementByClass = elementById.firstChild(css: ".swp-style") {
//                        print(elementByClass)
//                        print("****************************")
                        
                        let td =  elementByClass.css("td")
//                        var counter = 0
//                        for value in td{
//                            print(String(counter)+":"+value.rawXML)
//                            counter += 1
//                        }
//                        print("トルコリラ/円")
//                        print(td[18].description)//付与日数
//                        print(td[23].stringValue)//買いスワップ
//                        print(td[28].document)//売りスワップ
                        self.AddDateLabel.text = td[18].stringValue
                        self.BuySwapLabel.text = td[23].stringValue
                        self.SellSwapLabel.text = td[28].stringValue
                        
                        self.SumMoneyLabel.text = String(Float64(self.BuySwapLabel.text!)!*100)
                        
                    }
                }
                
                
            } catch let error {
                print(error)
            }
            
            
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

