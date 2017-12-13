//
//  SwapCalendarViewController.swift
//  Todays_Swap
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 sekibotbot. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Fuzi

class SwapCalendarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var TodayLabel: UILabel!
    @IBOutlet weak var TodayAddDateLabel: UILabel!
    @IBOutlet weak var TodayBuySwapLabel: UILabel!
    @IBOutlet weak var TodaySellSwapLabel: UILabel!
    
    @IBOutlet weak var CalenderCollectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 29//ぶっちゃけ何個でもいいんだけど上限は２９
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CalendarCellCollectionViewCell
        
        cell.CellDateLabel.text = date[indexPath.row]
        cell.CellBuySwapLabel.text = buy_swap[indexPath.row]
        cell.CellSellSwapLabel.text = sell_swap[indexPath.row]
        cell.CellAddDateLabel.text = add_date[indexPath.row]
        
        if(add_date[indexPath.row] == "-" || add_date[indexPath.row] == ""){//付与日数がしょぼい場合
            cell.backgroundColor = UIColor.white
        }else{
            switch Int(add_date[indexPath.row])!{
            case 0:
                cell.backgroundColor = UIColor.white
//                print("case 0")
            case 1:
                cell.backgroundColor = UIColor.white
//                print("case 1")
            case 2:
                cell.backgroundColor = UIColor.white
//                print("case 2")
            default:
                cell.backgroundColor = UIColor.yellow
            }
        }
        
        return cell
    }
    


    var date = [String](repeating: "", count: 29)
    var add_date = [String](repeating: "", count: 29)
    var buy_swap = [String](repeating: "", count: 29)
    var sell_swap = [String](repeating: "", count: 29)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalenderCollectionView.delegate = self
        CalenderCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        Alamofire.request("https://www.moneypartners.co.jp/market/swap/nano/", method: .get).responseString(completionHandler: {response in
            // ここに処理を記述していく
//                        print(response)
            let html = response.value!
            do {
                // if encoding is omitted, it defaults to NSUTF8StringEncoding
                let doc = try HTMLDocument(string: html, encoding: String.Encoding.utf8)
                
                // CSS queries
                if let elementById = doc.firstChild(css: "#02") {
//                                        print(elementById)
//                                        print("****************************")
                    if let elementByClass = elementById.firstChild(css: ".inner") {
                        //                        print(elementByClass)
//                                                print("****************************")
                        
                        let td =  elementByClass.css("td")
                        var counter = 0
                        for value in td{
                            switch counter%13 {
                            case 12://日付
                                self.date[counter/13] = value.stringValue
                            case 6://付与日数
                                if(counter != 6){
                                    self.add_date[counter/13-1] = value.stringValue
                                }
                            case 7://会スワップ
                                if(counter != 7){
                                    self.buy_swap[counter/13-1] = value.stringValue
                                }
                            case 8://売りスワップ
                                if(counter != 8){
                                    self.sell_swap[counter/13-1] = value.stringValue
                                }
                            default:
                                break
                            }
//                            print(String(counter)+":"+value.rawXML)
                            counter += 1
                            
                        }
                        //+13周期
                        //日付
                        //12,25,38---376
                        //付与日数
                        //19,32---383
                        //会スワップ
                        //20,33---384
                        //売りスワップ
                        //21,34---385
                        
//                        print("トルコリラ/円")
//                        print(td[18].description)//付与日数
//                        print(td[23].stringValue)//買いスワップ
//                        print(td[28].document)//売りスワップ


                    }
                }
                
//                print(self.date)
//                print(self.add_date)
//                print(self.buy_swap)
//                print(self.sell_swap)
                //本日のindexを取得
                let index = self.date.index(of: self.getToday())
                self.TodayLabel.text = self.date[index!]
                self.TodayAddDateLabel.text = self.add_date[index!-1]
                self.TodayBuySwapLabel.text = self.buy_swap[index!-1]
                self.TodaySellSwapLabel.text = self.sell_swap[index!-1]
                

                self.CalenderCollectionView.reloadData()
            } catch let error {
                print(error)
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getToday(format:String = "MM/dd") -> String {
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
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
