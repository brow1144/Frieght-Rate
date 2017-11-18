//
//  ViewController.swift
//  Freight-Rate
//
//  Created by Kyle Brown on 8/16/17.
//  Copyright © 2017 Kyle Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tonsPerTruckLoad: UITextField!
    @IBOutlet var targetRatePerHour: UITextField!
    @IBOutlet var haulTimeToJob: UITextField!
    @IBOutlet var percAddForTruckVsCar: UITextField!
    @IBOutlet var loadingTime: UITextField!
    @IBOutlet var unloadingTime: UITextField!
    @IBOutlet var mileageSubjectToTolls: UITextField!
    @IBOutlet var tollsPerMile: UITextField!
    @IBOutlet var isBackhaul: UISwitch!
    @IBOutlet var ratePerMinute: UILabel!
    @IBOutlet var loadingTimeResult: UILabel!
    @IBOutlet var totalMinutes: UILabel!
    @IBOutlet var unloadingTimeResult: UILabel!
    @IBOutlet var totalMinutesFrom: UILabel!
    @IBOutlet var combinedTotalMinutes: UILabel!
    @IBOutlet var combinedTotalHours: UILabel!
    @IBOutlet var expectedTolls: UILabel!

    
    @IBOutlet var haulPricec: UILabel!
    
    @IBOutlet var pricePerTon: UILabel!

    
    var overallMintes: Double = 0.0
    var ratePerMintue: Double = 0.0
    var expectedTollPrice: Double = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tonsPerTruckLoad.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        targetRatePerHour.addTarget(self, action: #selector(myRateTextFieldDidChange), for: .editingChanged)
        tollsPerMile.addTarget(self, action: #selector(myTollFieldDidChange), for: .editingChanged)
    }
    
    @IBAction func refreshEverythinga(_ sender: UIButton) {
        tonsPerTruckLoad.text = ""
        targetRatePerHour.text = ""
        haulTimeToJob.text = ""
        percAddForTruckVsCar.text = ""
        loadingTime.text = ""
        unloadingTime.text = ""
        mileageSubjectToTolls.text = ""
        tollsPerMile.text = ""
        
        ratePerMinute.text = "$0.00"
        loadingTimeResult.text = "0"
        totalMinutes.text = "0"
        unloadingTimeResult.text = "0"
        totalMinutesFrom.text = "0"
        combinedTotalMinutes.text = "0"
        combinedTotalHours.text = "0"
        expectedTolls.text = "$0.00"
        
        haulPricec.text = "$0.00"
        pricePerTon.text = "$0.00"
        
        overallMintes = 0.0
        ratePerMintue = 0.0
        expectedTollPrice = 0.0
    }
    
    private func removeSymbols(_ string: String) -> String {
        let removal: [Character] = ["$"," ",",",".","%"]
        let unfilteredCharacters = string
        let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
        let filtered = String(filteredCharacters)
        return String(filtered)
    }
    
    func calcHaulPrice() {
        var tons = tonsPerTruckLoad.text
        if (tonsPerTruckLoad.text == "") { tons = "0" }

        if (overallMintes != 0 && ratePerMintue != 0  ) {
            var finalHaul = String((Double(overallMintes) * Double(ratePerMintue)) + Double(expectedTollPrice))
            var finalPerTon = String((Double(finalHaul)! / Double(tons!)!))
            
            finalPerTon = String(Double(finalPerTon)!.rounded(toPlaces: 2) * 10)
            finalPerTon = String(finalPerTon).currencyInputFormatting()
            finalHaul = String(Double(finalHaul)!.rounded(toPlaces: 2) * 10 )
            finalHaul = (finalHaul.currencyInputFormatting())
    
            haulPricec.text = finalHaul
            pricePerTon.text = finalPerTon
            
        } else {
            haulPricec.text = "$0.00"
            pricePerTon.text = "$0.00"
        }
    }
    
    func calcOverallMinute() {
        
        var loading = loadingTime.text
        var unloading = unloadingTime.text
        var total = totalMinutes.text
        
        if (loadingTime.text == "") { loading = "0" }
        if (unloadingTime.text == "") { unloading = "0" }
        if (totalMinutes.text == "") { total = "0" }

        
        if (loadingTime.text != nil && unloadingTime.text != nil && totalMinutes != nil ) {
            if (isBackhaul.isOn) {
                overallMintes = Double(loading!)! + Double(unloading!)! + Double(total!)!
                overallMintes = Double(overallMintes).rounded(toPlaces: 0)
            } else {
                overallMintes = Double(loading!)! + Double(unloading!)! + Double(total!)! + Double(total!)!
                overallMintes = Double(overallMintes).rounded(toPlaces: 0)
            }
        }
        combinedTotalMinutes.text = String(Int(overallMintes))
        combinedTotalHours.text = String((Double(overallMintes) / 60).rounded(toPlaces: 2) )
        //calcHaulPrice()
    }
    
    func renderLoadingTime() {
        if (loadingTime.text != "") {
            loadingTimeResult.text = loadingTime.text
        } else {
            loadingTimeResult.text = "0"
        }
        calcOverallMinute()
        //calcHaulPrice()
    }
    
    func renderTotalMinutesToHaul() {
        var realHaulTime = removeSymbols(haulTimeToJob.text!)
        var realPercTime = removeSymbols(percAddForTruckVsCar.text!)
        
        if (percAddForTruckVsCar.text == "") { realPercTime = "0" }
        if (haulTimeToJob.text! == "") { realHaulTime = "0" }
        
        if (Double(realHaulTime) != nil && Double(realPercTime) != nil) {
            let decimalPercent = String(Double(realPercTime)! / 100)
            let loadingResult = Double(realHaulTime)! + (Double(decimalPercent)! * Double(realHaulTime)!)
            totalMinutes.text = String(Double(loadingResult))
        }
        
        if (isBackhaul.isOn) {
            totalMinutesFrom.text = "0"
        } else {
            totalMinutesFrom.text =  String(Int(Double(totalMinutes.text!)!.rounded(toPlaces: 0)))
        }
        calcOverallMinute()
        //calcHaulPrice()
    }
    
    func renderUnLoadingTime() {
        if (unloadingTime.text != "") {
            unloadingTimeResult.text = unloadingTime.text
        } else {
            unloadingTimeResult.text = "0"
        }
        calcOverallMinute()
        //calcHaulPrice()
    }
    
    @objc func myTollFieldDidChange(_ textField: UITextField) {
        if let amountString = tollsPerMile.text?.currencyInputFormatting() {
            textField.text = amountString
            var realInt = removeSymbols(amountString)
            var milage = mileageSubjectToTolls.text!
            
            if (tollsPerMile.text! == "") { realInt = "0" }
            if (mileageSubjectToTolls.text == "") { milage = "0" }
            
            if (Double(realInt) != nil) {
                let tollsPerMileInt = round(100 * (Double(realInt)!/100) * ( Double(milage)!) ) / 100
                expectedTollPrice = tollsPerMileInt
                expectedTolls.text = "$" + String(tollsPerMileInt)
            }
        }
        calcOverallMinute()
        calcHaulPrice()
    }
    
    func renderMilageTolls() {
        if let amountStirng = tollsPerMile.text?.currencyInputFormatting() {
            var realInt = removeSymbols(amountStirng)
            var milage = mileageSubjectToTolls.text!
            
            if (tollsPerMile.text! == "") { realInt = "0" }
            if (mileageSubjectToTolls.text == "") { milage = "0" }
            
            if (Double(milage) != nil && Double(realInt) != nil) {
                let tollsPerMileInt = round(100 * (Double(realInt)!/100) * ( Double(milage)!) ) / 100
                expectedTollPrice = tollsPerMileInt
                expectedTolls.text = "$" + String(tollsPerMileInt)
            }
        }
        calcOverallMinute()
        //calcHaulPrice()
    }
    
    @IBAction func renderSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            totalMinutesFrom.text = "0"
        } else {
            totalMinutesFrom.text =  String(Int(Double(totalMinutes.text!)!.rounded(toPlaces: 0)))
        }
        calcOverallMinute()
    }
    
    @IBAction func renderResults(_ sender: UITextField, forEvent event: UIEvent) {
        renderLoadingTime()
        renderTotalMinutesToHaul()
        renderUnLoadingTime()
        renderMilageTolls()
        calcOverallMinute()
        calcHaulPrice()
    }
    
    @objc func myRateTextFieldDidChange(_ textField: UITextField) {
        if let amountString = targetRatePerHour.text?.currencyInputFormatting() {
            textField.text = amountString
            
            let realInt = removeSymbols(amountString)
            
            if (Double(realInt) != nil) {
                let real = Double(realInt)!/6000
                let ratePerMinuteInt = Double(real).rounded(toPlaces: 2) * 10
                ratePerMintue = Double(real).rounded(toPlaces: 2)
                ratePerMinute.text = String(ratePerMinuteInt).currencyInputFormatting()
                
            } else {
                ratePerMinute.text = "$0.00"
            }
        }
        calcOverallMinute()
        calcHaulPrice()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}











