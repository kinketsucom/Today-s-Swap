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

class ViewController: UIViewController {


    @IBOutlet weak var BuySwapLabel: UILabel!
    @IBOutlet weak var SellSwapLabel: UILabel!
    @IBOutlet weak var AddDateLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        print("トルコリラ/円")
                        print(td[18].description)//付与日数
                        print(td[23].stringValue)//買いスワップ
                        print(td[28].document)//売りスワップ
                        self.AddDateLabel.text = td[18].stringValue
                        self.BuySwapLabel.text = td[23].stringValue
                        self.SellSwapLabel.text = td[28].stringValue
                        
                        
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

