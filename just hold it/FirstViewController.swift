//
//  FirstViewController.swift
//  just hold it
//
//  Created by Enrique Chavez on 21/01/15.
//  Copyright (c) 2015 Enrique Chavez. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var higherLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
    
    var startTime = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    var currentScore = 0.0;
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBtn.layer.cornerRadius = 5
        showUserScores()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime: NSTimeInterval = currentTime - startTime
        let time = convertTimeToHumanRead( elapsedTime )!
        let hours = time["hours"]!
        let minutes = time["minutes"]!
        let seconds = time["seconds"]!
        let fraction = time["fraction"]!
        
        currentScore = elapsedTime

        counter.text = "\(hours):\(minutes):\(seconds)"
        fractionLabel.text = "\(fraction)"
        
    }

    func convertTimeToHumanRead(elapsedTime:NSTimeInterval) -> [String:String]?{
        
        var elapsedVar = elapsedTime
        let hours = NSInteger( (elapsedVar / 60.0) / 60.0 )
        elapsedVar -= (NSTimeInterval(hours) * 60) * 60
        
        
        let minutes = NSInteger(elapsedVar / 60.0)
        elapsedVar -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = NSInteger(elapsedVar)
        elapsedVar -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = NSInteger(elapsedVar * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strHours = hours > 9 ? String(hours):"0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        return ["hours": strHours, "minutes": strMinutes, "seconds": strSeconds, "fraction": strFraction]
    }
    
    func showUserScores(){
        if let latestScore:AnyObject = userDefaults.valueForKey("latestScore") {
            setScoreValuesToLabel(label: latestLabel, time: latestScore as NSTimeInterval)
        }
        
        if let higherScore:AnyObject = userDefaults.valueForKey("higherScore") {
            setScoreValuesToLabel(label: higherLabel, time: higherScore as NSTimeInterval)
            
        }
        
        
    }
    
    func saveLatestCore(){
        println("Saving: \(currentScore)")
        
        if let higherScore:AnyObject = userDefaults.valueForKey("higherScore"){
            if Double( currentScore ) > higherScore as Double {
                setScoreValuesToLabel(label: higherLabel, time: currentScore as NSTimeInterval)
                userDefaults.setValue(currentScore, forKey: "higherScore")
            }
            
        }else{
            setScoreValuesToLabel(label: higherLabel, time: currentScore as NSTimeInterval)
            userDefaults.setValue(currentScore, forKey: "higherScore")
        }
        setScoreValuesToLabel(label: latestLabel, time: currentScore as NSTimeInterval)
        userDefaults.setValue(currentScore, forKey: "latestScore")

    }
    
    func setScoreValuesToLabel( #label:UILabel, time:NSTimeInterval ){
        let value = convertTimeToHumanRead( time )!
        var hours = value["hours"]!
        var minutes = value["minutes"]!
        var seconds = value["seconds"]!
        var fraction = value["fraction"]!
        label.text = "\(hours):\(minutes):\(seconds):\(fraction)"
    }


    @IBAction func tapIn(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
  
    @IBAction func tapOutside(sender: AnyObject) {
        timer.invalidate()
        saveLatestCore()
    }

}

