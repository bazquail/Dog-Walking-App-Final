//
//  WalkerView.swift
//  Do Walking App
//
//  Created by Elias Topp on 10/12/16.
//  Copyright © 2016 Topp Minds. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class WalkerView: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let username = UserDefaults.standard.string(forKey: "username")!
    let appleButtonColorColorBlueWithTheFur = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    //var user: User!
    
    //Things that need to run immediately
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBank.delegate = self
        commentBank.text = "Comments, Notes, or Concerns"
        commentBank.textColor = UIColor.lightGray
        if UserDefaults.standard.array(forKey: "days") != nil {
            daysArray = UserDefaults.standard.array(forKey: "days") as! [String] }
        toolBarCreation(sender: commentBank)
        tableCreation()
        welcomeLabelFunc()
        saveTimeIn()
        sizingElements()
        
        /*FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }*/
    }
    
    var dataTextView: UITextView!
    var tableView: UITableView = UITableView()
    
    var daysArray: [String] = []
    var peeArray: [String] = []
    var poopArray: [String] = []
    var feedArray: [String] = []
    var medArray: [String] = []
    var walkArray: [String] = []
    var walkLengthArray: [String] = []
    var commentArray: [String] = []
    
    var timeIn: String!
    var timeOut: String!
    var timeOfDay: String!
    var boxname: UITextField!
    var fieldname: UITextView!
    var dogPeed = false
    var dogPooped = false
    var dogFed = false
    var dogMeds = false
    var casesBool: Bool!
    var originalY: CGFloat!
    var textType: UIView!
    var dayDate: String!
    var currentDate: String!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBAction func signOut(_ sender: AnyObject) {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeOut = dateFormatter.string(from: date as Date)
        UserDefaults.standard.set(timeOut, forKey: "time out")
    }
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    
    //label init
    
    @IBOutlet weak var peedLabel: UILabel!
    @IBOutlet weak var poopedLabel: UILabel!
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var fedLabel: UILabel!
    @IBOutlet weak var walkLabel: UILabel!
    
    //Reset data fields
    
    @IBAction func resetData(_ sender: UIButton) {
        peeSegment.selectedSegmentIndex = -1
        peeSegment.tintColor = appleButtonColorColorBlueWithTheFur
        poopSegment.selectedSegmentIndex = -1
        poopSegment.tintColor = appleButtonColorColorBlueWithTheFur
        feedSegment.selectedSegmentIndex = -1
        feedSegment.tintColor = appleButtonColorColorBlueWithTheFur
        medSegment.selectedSegmentIndex = -1
        medSegment.tintColor = appleButtonColorColorBlueWithTheFur
        dogPeed = false
        dogPooped = false
        dogFed = false
        dogMeds = false
        peeTimeBox.text = nil
        peeTimeBox.layer.borderWidth = 0
        poopTimeBox.text = nil
        poopTimeBox.layer.borderWidth = 0
        feedTimeBox.text = nil
        feedTimeBox.layer.borderWidth = 0
        medTimeBox.text = nil
        medTimeBox.layer.borderWidth = 0
        distanceBox.text = nil
        distanceBox.layer.borderWidth = 0
        walkFinishTimeBox.text = nil
        walkFinishTimeBox.layer.borderWidth = 0
        walkStartTimeBox.text = nil
        walkStartTimeBox.layer.borderWidth = 0
        commentBank.text = "Comments, Notes, or Concerns"
        commentBank.textColor = UIColor.lightGray
    }
    
    //Make Table
    
    func tableCreation() {
        tableView.frame = CGRect(x: 0, y: view.frame.size.height * 1.5, width: view.frame.size.width, height: view.frame.size.height)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(appleButtonColorColorBlueWithTheFur, for: .normal)
        btn.frame = CGRect(x: view.frame.size.width * 0.8, y: view.frame.size.height * 0.01, width: 60, height: 30)
        btn.addTarget(self, action: #selector(WalkerView.dismissTable), for: .touchUpInside)
        tableView.addSubview(btn)
        
        self.view.addSubview(tableView)
    }
    
    func dismissTable() {
        UIView.animate(withDuration: 0.5, animations: {
        self.tableView.frame.origin.y = self.view.frame.size.height * 1.5
            if self.dataTextView != nil { self.removeDataView() }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.daysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.daysArray[((daysArray.count - 1) - indexPath.row)]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentDate = tableView.cellForRow(at: indexPath)!.textLabel!.text
        dataViewer()
    }
    
    //VIEW DATAAAAAAAA
    
    func dataViewer() {
        removeDataView()
        dataTextView = UITextView(frame: CGRect(x: view.frame.size.width * 0.05, y: (view.frame.size.height * 0.5) - (commentBank.frame.size.height / 2), width: commentBank.frame.size.width, height: commentBank.frame.size.height))
        dataTextView.backgroundColor = commentBank.backgroundColor
        
        dataTextView.text = "Peed: \((UserDefaults.standard.array(forKey: "pee \(currentDate)") as! [String]).joined(separator: ", ")) \nPooped: \((UserDefaults.standard.array(forKey: "poop \(currentDate)") as! [String]).joined(separator: ", ")) \nFed: \((UserDefaults.standard.array(forKey: "feed \(currentDate)") as! [String]).joined(separator: ", ")) \nMeds: \((UserDefaults.standard.array(forKey: "med \(currentDate)") as! [String]).joined(separator: ", ")) \nWalk Distance: \((UserDefaults.standard.array(forKey: "walk \(currentDate)") as! [String]).joined(separator: ", ")) \nWalk Length: \((UserDefaults.standard.array(forKey: "walkLength \(currentDate)") as! [String]).joined(separator: ", ")) \nComments: \((UserDefaults.standard.array(forKey: "comment \(currentDate)") as! [String]).joined(separator: "\n"))"
        
        dataTextView.isEditable = false
        self.view.addSubview(dataTextView)
        
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(WalkerView.removeDataView), for: .touchUpInside)
        btn.frame = CGRect(x: view.frame.size.width * 0.74, y: view.frame.size.height * -0.01, width: 60, height: 30)
        dataTextView.addSubview(btn)
    }
    
    func removeDataView() {
        if dataTextView != nil {
        dataTextView.removeFromSuperview()
        }
    }
    
    //Save button data saver
    
    @IBAction func checkStats(_ sender: UIButton) {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dayDate = dateFormatter.string(from: date as Date)
        
        if daysArray.contains(dayDate) {
            print("day Already exists!")
        } else { daysArray.append(dayDate)
            UserDefaults.standard.set(false, forKey: "has run today") }
        
        tableView.reloadData()
        
        if dogPeed == true && peeArray.contains(peeTimeBox.text!) == false && peeTimeBox.text != "" {
            peeArray.append(peeTimeBox.text!)
            UserDefaults.standard.set(peeArray, forKey: "pee \(dayDate)") }
        if dogPooped == true && poopArray.contains(poopTimeBox.text!) == false && poopTimeBox.text != "" {
            poopArray.append(poopTimeBox.text!)
            UserDefaults.standard.set(poopArray, forKey: "poop \(dayDate)") }
        if dogFed == true && feedArray.contains(feedTimeBox.text!) == false && feedTimeBox.text != "" {
            feedArray.append(feedTimeBox.text!)
            UserDefaults.standard.set(feedArray, forKey: "feed \(dayDate)") }
        if dogMeds == true && medArray.contains(medTimeBox.text!) == false && medTimeBox.text != "" {
            medArray.append(medTimeBox.text!)
            UserDefaults.standard.set(medArray, forKey: "med \(dayDate)") }
        
        if distanceBox.text != "" && walkLengthArray.contains(walkStartTimeBox.text! + " - " + walkFinishTimeBox.text!) == false && walkStartTimeBox.text != "" && walkFinishTimeBox.text != "" {
            walkArray.append((distanceBox.text! + " miles"))
            UserDefaults.standard.set(walkArray, forKey: "walk \(dayDate)")
            walkLengthArray.append((walkStartTimeBox.text! + " - " + walkFinishTimeBox.text!))
            UserDefaults.standard.set(walkLengthArray, forKey: "walkLength \(dayDate)") }
        
        if commentBank.textColor != UIColor.lightGray {
            commentArray.append(("\(username): " + commentBank.text))
            UserDefaults.standard.set(commentArray, forKey: "comment \(dayDate)") }
        
        //MAKE RED FOR CONFLICTING INFO
        
        peeTimeBox.layer.cornerRadius = 5
        peeTimeBox.layer.masksToBounds = true
        peeTimeBox.layer.borderColor = UIColor.red.cgColor
        
        poopTimeBox.layer.masksToBounds = true
        poopTimeBox.layer.borderColor = UIColor.red.cgColor
        poopTimeBox.layer.cornerRadius = 5
        
        medTimeBox.layer.borderColor = UIColor.red.cgColor
        medTimeBox.layer.cornerRadius = 5
        medTimeBox.layer.masksToBounds = true
        
        feedTimeBox.layer.cornerRadius = 5
        feedTimeBox.layer.borderColor = UIColor.red.cgColor
        feedTimeBox.layer.masksToBounds = true
        
        if dogPeed == false && peeTimeBox.text != "" {
            peeSegment.tintColor = UIColor.red }
        if dogPooped == false && poopTimeBox.text != "" {
            poopSegment.tintColor = UIColor.red }
        if dogFed == false && feedTimeBox.text != "" {
            feedSegment.tintColor = UIColor.red }
        if dogMeds == false && medTimeBox.text != "" {
            medSegment.tintColor = UIColor.red }
        if dogPeed == true && peeTimeBox.text == "" {
            peeTimeBox.layer.borderWidth = 1 }
        if dogPooped == true && poopTimeBox.text == "" {
            poopTimeBox.layer.borderWidth = 1 }
        if dogFed == true && feedTimeBox.text == "" {
            feedTimeBox.layer.borderWidth = 1 }
        if dogMeds == true && medTimeBox.text == "" {
            medTimeBox.layer.borderWidth = 1 }
        
        //MAke red the walk boxes
        
        walkFinishTimeBox.layer.cornerRadius = 5
        walkFinishTimeBox.layer.masksToBounds = true
        walkFinishTimeBox.layer.borderColor = UIColor.red.cgColor
        
        distanceBox.layer.borderColor = UIColor.red.cgColor
        distanceBox.layer.cornerRadius = 5
        distanceBox.layer.masksToBounds = true
        
        walkStartTimeBox.layer.borderColor = UIColor.red.cgColor
        walkStartTimeBox.layer.cornerRadius = 5
        walkStartTimeBox.layer.masksToBounds = true
        
        if distanceBox.text != "" && (walkStartTimeBox.text == "" || walkFinishTimeBox.text == "") {
            if walkStartTimeBox.text == "" { walkStartTimeBox.layer.borderWidth = 1 }
            if walkFinishTimeBox.text == "" { walkFinishTimeBox.layer.borderWidth = 1 } }
          else if walkStartTimeBox.text != "" && (distanceBox.text == "" || walkFinishTimeBox.text == "") {
            if walkFinishTimeBox.text == "" { walkFinishTimeBox.layer.borderWidth = 1 }
            if distanceBox.text == "" { distanceBox.layer.borderWidth = 1 } }
          else if walkFinishTimeBox.text != "" && (distanceBox.text == "" || walkStartTimeBox.text == "") {
            if distanceBox.text == "" { distanceBox.layer.borderWidth = 1 }
            if walkStartTimeBox.text == "" { walkStartTimeBox.layer.borderWidth = 1 } }
        
        UserDefaults.standard.set(daysArray, forKey: "days")
        if UserDefaults.standard.bool(forKey: "has run today") == false {
            UserDefaults.standard.set(peeArray, forKey: "pee \(dayDate)")
            UserDefaults.standard.set(poopArray, forKey: "poop \(dayDate)")
            UserDefaults.standard.set(feedArray, forKey: "feed \(dayDate)")
            UserDefaults.standard.set(medArray, forKey: "med \(dayDate)")
            UserDefaults.standard.set(walkArray, forKey: "walk \(dayDate)")
            UserDefaults.standard.set(walkLengthArray, forKey: "walkLength \(dayDate)")
            UserDefaults.standard.set(commentArray, forKey: "comment \(dayDate)")
            UserDefaults.standard.set(true, forKey: "has run today")
        }
    }
    
    @IBOutlet weak var peeTimeBox: UITextField!
    @IBOutlet weak var poopTimeBox: UITextField!
    @IBOutlet weak var feedTimeBox: UITextField!
    @IBOutlet weak var medTimeBox: UITextField!
    
    @IBOutlet weak var peeSegment: UISegmentedControl!
    @IBOutlet weak var poopSegment: UISegmentedControl!
    @IBOutlet weak var feedSegment: UISegmentedControl!
    @IBOutlet weak var medSegment: UISegmentedControl!
    
    @IBAction func dogPeed(_ sender: UISegmentedControl) {
        actionCases(sender: sender)
        dogPeed = casesBool
        if dogPeed == false {
            peeTimeBox.text = nil
            peeTimeBox.layer.borderWidth = 0
        }
    }

    @IBAction func dogPoopedAction(_ sender: UISegmentedControl) {
        actionCases(sender: sender)
        dogPooped = casesBool
        if dogPooped == false {
            poopTimeBox.text = nil
            poopTimeBox.layer.borderWidth = 0
        }
    }
    
    @IBAction func dogFedAction(_ sender: UISegmentedControl) {
        actionCases(sender: sender)
        dogFed = casesBool
        if dogFed == false {
            feedTimeBox.text = nil
            feedTimeBox.layer.borderWidth = 0
        }
    }
    
    @IBAction func dogMedAction(_ sender: UISegmentedControl) {
        actionCases(sender: sender)
        dogMeds = casesBool
        if dogMeds == false {
            medTimeBox.text = nil
            medTimeBox.layer.borderWidth = 0
        }
    }

    func actionCases(sender: UISegmentedControl) {
        sender.tintColor = appleButtonColorColorBlueWithTheFur
        switch sender.selectedSegmentIndex {
            case 0:
                casesBool = true
            case 1:
                casesBool = false
            default:
                break;
        }
    }
    
    //Walk config code
    
    @IBOutlet weak var distanceBox: UITextField!
    @IBOutlet weak var walkFinishTimeBox: UITextField!
    @IBOutlet weak var walkStartTimeBox: UITextField!
    
    //Time Text Fields
    
    @IBAction func peeBoxAction(_ sender: UITextField!) {
        boxname = peeTimeBox
        peeTimeBox.layer.borderWidth = 0
        datePickerCode(sender)
    }
    @IBAction func poopBoxAction(_ sender: UITextField) {
        boxname = poopTimeBox
        poopTimeBox.layer.borderWidth = 0
        datePickerCode(sender)
    }
    @IBAction func feedTimeAction(_ sender: UITextField!) {
        boxname = feedTimeBox
        feedTimeBox.layer.borderWidth = 0
        datePickerCode(sender)
    }
    @IBAction func medTimeAction(_ sender: UITextField) {
        boxname = medTimeBox
        medTimeBox.layer.borderWidth = 0
        datePickerCode(sender)
    }
    @IBAction func walkStartTimeAction(_ sender: UITextField) {
        boxname = walkStartTimeBox
        walkStartTimeBox.layer.borderWidth = 0
        datePickerCode(sender)
    }
    @IBAction func walkFinishTimeAction(_ sender: UITextField) {
        boxname = walkFinishTimeBox
        walkFinishTimeBox.layer.borderWidth = 0
        datePickerCode(sender)
    }
    @IBAction func walkDistanceAction(_ sender: UITextField) {
        boxname = distanceBox
        distanceBox.layer.borderWidth = 0
        toolBarCreationTextField(sender: distanceBox)
    }
    
    //Comment Bank code
    
    @IBOutlet weak var commentBank: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.bringSubview(toFront: commentBank)
        if commentBank.textColor == UIColor.lightGray {
            commentBank.text = nil
            commentBank.textColor = UIColor.black
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            
        self.originalY = self.commentBank.frame.origin.y
        self.commentBank.frame.origin.y = self.view.frame.size.height * 0.15 })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentBank.text.isEmpty {
            commentBank.text = "Comments, Notes, or Concerns"
            commentBank.textColor = UIColor.lightGray
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.commentBank.frame.origin.y = self.originalY })
    }
    
    //Tool bar code
    
    func toolBarCreation(sender: UITextView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = appleButtonColorColorBlueWithTheFur
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WalkerView.returnPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sender.inputAccessoryView = toolBar
        fieldname = sender
    }
    
    func toolBarCreationTextField(sender: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = appleButtonColorColorBlueWithTheFur
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WalkerView.returnPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sender.inputAccessoryView = toolBar
        boxname = sender
    }
    
    //Date Picker code
    
    func datePickerCode(_ sender: UITextField!) {
        let DatePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        DatePickerView.datePickerMode = .time
        sender.inputView = DatePickerView
        DatePickerView.addTarget(self, action: #selector(WalkerView.handleDatePicker), for: .valueChanged)
        toolBarCreationTextField(sender: sender)
    }
    
    func returnPicker() {
        if boxname != nil {
        boxname.resignFirstResponder() }
        if fieldname != nil {
        fieldname.resignFirstResponder() }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        boxname.text = dateFormatter.string(from: sender.date)
    }
    
    //View history of dog visits
    
    @IBAction func showHistory(_ sender: UIButton) {
        self.view.bringSubview(toFront: tableView)
        UIView.animate(withDuration: 0.5, animations: {
        self.tableView.frame.origin.y = self.view.frame.size.height * 0.05
        })
    }
    
    //Welcome Label
    
    func welcomeLabelFunc() {
    welcomeLabel.text = "Welcome, \(username)!"
    welcomeLabel.sizeToFit()
    welcomeLabel.frame.origin.x = (view.frame.size.width * 0.5) - (welcomeLabel.frame.size.width * 0.5)
    }

    //Log Time in
    
    func saveTimeIn() {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeIn = dateFormatter.string(from: date as Date)
        timeInLabel.text = "Time In: \(timeIn!)"
        timeInLabel.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sizingElements() {
        
        //Y POSITION
        
        welcomeLabel.frame.origin.y = view.frame.size.height * 0.049
        timeInLabel.frame.origin.y = view.frame.size.height * 0.1109
        signOutButton.frame.origin.y = view.frame.size.height * 0.0809
        resetButton.frame.origin.y = view.frame.size.height * 0.1214
        peedLabel.frame.origin.y = view.frame.size.height * 0.1936
        poopedLabel.frame.origin.y = view.frame.size.height * 0.2570
        fedLabel.frame.origin.y = view.frame.size.height * 0.3151
        medLabel.frame.origin.y = view.frame.size.height * 0.3785
        peeSegment.frame.origin.y = view.frame.size.height * 0.1901
        poopSegment.frame.origin.y = view.frame.size.height * 0.2517
        feedSegment.frame.origin.y = view.frame.size.height * 0.3098
        medSegment.frame.origin.y = view.frame.size.height * 0.3714
        peeTimeBox.frame.origin.y = view.frame.size.height * 0.1883
        poopTimeBox.frame.origin.y = view.frame.size.height * 0.2482
        feedTimeBox.frame.origin.y = view.frame.size.height * 0.3098
        medTimeBox.frame.origin.y = view.frame.size.height * 0.3714
        walkLabel.frame.origin.y = view.frame.size.height * 0.4823
        distanceBox.frame.origin.y = view.frame.size.height * 0.4735
        walkStartTimeBox.frame.origin.y = distanceBox.frame.origin.y
        walkFinishTimeBox.frame.origin.y = distanceBox.frame.origin.y
        commentBank.frame.origin.y = view.frame.size.height * 0.5563
        saveButton.frame.origin.y = view.frame.size.height * 0.93309
        viewButton.frame.origin.y = saveButton.frame.origin.y
        
        //X POSITION
        
        commentBank.frame.origin.x = view.frame.size.width * 0.05
        peeSegment.frame.origin.x = view.frame.size.width * 0.3156
        poopSegment.frame.origin.x = peeSegment.frame.origin.x
        feedSegment.frame.origin.x = peeSegment.frame.origin.x
        medSegment.frame.origin.x = peeSegment.frame.origin.x
        peeTimeBox.frame.origin.x = view.frame.size.width * 0.6812
        poopTimeBox.frame.origin.x = peeTimeBox.frame.origin.x
        feedTimeBox.frame.origin.x = peeTimeBox.frame.origin.x
        medTimeBox.frame.origin.x = peeTimeBox.frame.origin.x
        distanceBox.frame.origin.x = view.frame.size.width * 0.2062
        walkStartTimeBox.frame.origin.x = view.frame.size.width * 0.4531
        walkFinishTimeBox.frame.origin.x = view.frame.size.width * 0.7062
        
        //WIDTH
        
        peeTimeBox.frame.size.width = view.frame.size.width * 0.2687
        peeSegment.frame.size.width = peeTimeBox.frame.size.width
        poopSegment.frame.size.width = peeSegment.frame.size.width
        feedSegment.frame.size.width = peeSegment.frame.size.width
        medSegment.frame.size.width = peeSegment.frame.size.width
        poopTimeBox.frame.size.width = peeTimeBox.frame.size.width
        feedTimeBox.frame.size.width = peeTimeBox.frame.size.width
        medTimeBox.frame.size.width = peeTimeBox.frame.size.width
        distanceBox.frame.size.width = view.frame.size.width * 0.2343
        walkStartTimeBox.frame.size.width = view.frame.size.width * 0.2437
        walkFinishTimeBox.frame.size.width = walkStartTimeBox.frame.size.width
        commentBank.frame.size.width = view.frame.size.width * 0.9
        
        //HEIGHT
        
        commentBank.frame.size.height = view.frame.size.height * 0.3626
    }
}
