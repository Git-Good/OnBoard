//
//  TripViewController.swift
//  OnBoard
//
//  Created by George Cui on 11/7/15.
//  Copyright (c) 2015 Rainbow Riders. All rights reserved.
//

import UIKit
import CoreMotion


class TripViewController: UIViewController {
    // Outlet declarations
    @IBOutlet weak var graphZoneView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var endSessionButton: UIButton!
    
    // class-wise members
    var recentAccelerationData = [CMAcceleration]()
    var updateTimer : NSTimer?
    var user : User?
    var tempUser : User?
    override func viewDidLoad(){
        super.viewDidLoad()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
        self.resetMaxValues()
        user = UserManager.sharedInstance.currentUser
        tempUser = UserManager.sharedInstance.GetUserByName("Hy")
        for i in 0...9{
            recentAccelerationData.append(MotionManager.sharedInstance.GetCurrentAcceleration())
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when subview is drawed
    override func viewDidLayoutSubviews() {
        PlotGraph()
    }
    
    @IBAction func stopSession(sender: AnyObject) {
        SessionManager.sharedInstance.EndCurrentSession()
        updateTimer?.invalidate()
        endSessionButton.hidden = true
        UserManager.sharedInstance.Save()
        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        print(UserManager.sharedInstance.currentUser.SessionArray![0].SnapshotArray.count)

    }
    func UpdateRecentAccelerationData( acceleration : CMAcceleration){
        if(recentAccelerationData.count>10){
            recentAccelerationData.removeAtIndex(0)
        }
        recentAccelerationData.append(acceleration)
    }
    
    func update(){
        UpdateRecentAccelerationData(MotionManager.sharedInstance.GetCurrentAcceleration())
        PlotGraph()
        UpdateDurationLabel()
        SessionManager.sharedInstance.CurrentSession?.TakeSnapshot()
        UserManager.sharedInstance.currentUser
        //outputAccelerationData(MotionManager.sharedInstance.GetCurrentAcceleration())
    }
    
    
    // Dudation Label management
    func UpdateDurationLabel(){
        if let session = SessionManager.sharedInstance.CurrentSession {
            durationLabel.text = session.GetDurationHMSString()
        }
    }
    
    func GetPlotData()-> [TKChartDataPoint] {
        var myData = [TKChartDataPoint]()
        for (var i = 0; i < recentAccelerationData.count ;i++){
            var test = TKChartDataPoint(x: i, y: recentAccelerationData[i].x)
            myData.append(test)
        }
        return myData as [TKChartDataPoint]
    }

    
//    func GetPlotData()-> NSArray{
//        var myData = [[String : NSObject]]()
//        for (var i = 0; i < recentAccelerationData.count ;i++){
//            var test = ["label":i,"value":NSNumber(int: Int32(recentAccelerationData[i].x))]
//            myData.append(test)
//        }
//        return myData as NSArray
//    }
    
    func PlotGraph(){
        // Do any additional setup after loading the view.
        
        let graphArea = CGRect(x: 0, y: 0, width: self.graphZoneView.bounds.width, height: self.graphZoneView.bounds.height)
        
        let graph = TKChart(frame: CGRectInset(graphArea, 0, 25))
        graph.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue)
        self.graphZoneView.addSubview(graph)
        
        var dataSeries = TKChartLineSeries(items: GetPlotData())
        
        let fill = TKLinearGradientFill(colors: [UIColor(red: 0.92, green: 0.53, blue: 0.18, alpha: 1),
            UIColor(red: 0.95, green: 0.33, blue: 1.0, alpha: 1),
            UIColor(red: 0.18, green: 0.58, blue: 0.92, alpha: 1)])

        dataSeries.style.stroke = TKStroke(fill: fill, width: 2.0)
        
        graph.addSeries(dataSeries)
        
        graph.xAxis.hidden = true
        graph.yAxis.hidden = true
        
        let gridStyle = graph.gridStyle()
        gridStyle.horizontalAlternateFill = nil
        gridStyle.horizontalFill = nil
        gridStyle.horizontalLinesHidden = true
        
        graphZoneView.addSubview(graph)
        
    }
    
//    func PlotGraph(){
//        // Do any additional setup after loading the view.
//        
//        var x = graphZoneView.frame.width * 0.05;
//        var y = graphZoneView.frame.height * 0.05;
//        var width = graphZoneView.frame.width * 0.9
//        var height = graphZoneView.frame.height * 0.9
//        
//        let graph = StatusGraphView(frame: CGRectMake(x,y,width,height), data: GetPlotData())
//        for view in graphZoneView.subviews {
//            view.removeFromSuperview()
//        }
//        graphZoneView.addSubview(graph)
//        
//    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    //Instance Variables
    
    var currentMaxAccelerationX : Double = 0.00
    var currentMaxAccelerationY : Double = 0.00
    var currentMaxAccelerationZ : Double = 0.00
    
    var currentMaxRotationX : Double = 0.00
    var currentMaxRotationY : Double = 0.00
    var currentMaxRotationZ : Double = 0.00
    
    
    //Outlets
    
    @IBOutlet weak var AccelerationX: UILabel!
    @IBOutlet weak var AccelerationY: UILabel!
    @IBOutlet weak var AccelerationZ: UILabel!
    
    /* Max values, should move to Statistics page (after active session)
    @IBOutlet var MaxAccelerationX : UILabel?
    @IBOutlet var MaxAccelerationY : UILabel?
    @IBOutlet var MaxAccelerationZ : UILabel?
    */
    
    /* gyroscope data display
    
    @IBOutlet var RotationX : UILabel?
    @IBOutlet var RotationY : UILabel?
    @IBOutlet var RotationZ : UILabel?
    
    @IBOutlet var MaxRotationX : UILabel?
    @IBOutlet var MaxRotationY : UILabel?
    @IBOutlet var MaxRotationZ : UILabel?
    */
    
    //Functions
    
    @IBAction func resetMaxValues() {
        currentMaxAccelerationX = 0
        currentMaxAccelerationY = 0
        currentMaxAccelerationZ = 0
        
        
        currentMaxRotationX = 0
        currentMaxRotationY = 0
        currentMaxRotationZ = 0
        
    }
    
    
    func outputAccelerationData(acceleration :CMAcceleration)
    {
        AccelerationX.text = "\(acceleration.x)"
        
        if fabs(acceleration.x) > fabs(currentMaxAccelerationX)
        {
            
            currentMaxAccelerationX = acceleration.x
        }
        
        
        AccelerationY.text = "\(acceleration.x)"
        
        if fabs(acceleration.y) > fabs(currentMaxAccelerationY)
        {
            
            currentMaxAccelerationX = acceleration.x
        }
        
        AccelerationZ.text = "\(acceleration.z)"
        
        if fabs(acceleration.x) > fabs(currentMaxAccelerationZ)
        {
            
            currentMaxAccelerationZ = acceleration.z
        }
    }
}
