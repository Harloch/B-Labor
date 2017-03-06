//
//  PositiveNegativeViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class PositiveNegativeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var submitButton : UIButton!
    
    @IBOutlet weak var tableFooter: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var experience : ExperienceType!
    var quiz : NSArray!
    var selectedDictionary : NSMutableDictionary! = NSMutableDictionary()
    
    fileprivate var selectedTextfieldFrame: CGRect = CGRect.zero
    fileprivate var keyboardHeight: CGFloat = 0
    fileprivate let commentPlaceholder = "Comments"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // QUESTION AND ANSWERS
        
        self.quiz = [
            ["question" : "1. Were you made to feel welcomed upon arrival?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "2. Did the shop listen to your needs?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "3. Did you feel the advice given was trustworthy?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "4. Was the shop respectful towards your time?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "5. Was the invoice explained to you in full?", "answers" : ["Strongly Agree","Agree", "Somewhat Agree", "Disagree", "Strongly Disagree"]],
            ["question" : "6. Was the repair or service done correctly the first time?", "answers" : ["Yes","No"]],
            ["question" : "7. Are you satisfied with the repair or service?", "answers" : ["Yes","No"]],
            ["question" : "8. Would you recommend the shop to friends or family?", "answers" : ["Yes","No"]]]
        
        self.tableView.backgroundColor = UIColor.clear
        
        if let type = ExperienceType(rawValue: self.experience.rawValue){
            switch type {
            case .positive :
                self.navigationItem.title = "Posititve"
                self.submitButton.backgroundColor = UIColor(red: 9/255.0, green: 177/255.0, blue: 21/255.0, alpha: 1)
            case .negative :
                self.navigationItem.title = "Negative"
                self.submitButton.backgroundColor = UIColor.red
            }
            self.submitButton.setTitle("SUBMIT", for: UIControlState())
            self.submitButton.setTitle("SUBMIT", for: .highlighted)
        }
        
        let textfieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.Size.screenWidth.floatValue, height: 44))
        textfieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "didPressHideKeyboardButton:")]
        
        self.commentTextView.inputAccessoryView = textfieldToolbar
        let attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: attributesDictionary)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        self.shopNameTextField.attributedPlaceholder = NSAttributedString(string: "Name of Shop", attributes: attributesDictionary)
        self.commentTextView.placeholderColor = UIColor.white
        self.commentTextView.placeholder = self.commentPlaceholder
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(PositiveNegativeViewController.onKeyboardFrameChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction
    
    func didPressHideKeyboardButton(_ sender: UIBarButtonItem) {
        self.commentTextView.resignFirstResponder()
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        
        var userId = ""
        
        if (nil != defaults.value(forKey: "userID")) {
            userId = defaults.value(forKey: "userID") as! String
        } else {
            let alert = UIAlertController(title: "Warning", message: "Please Login to App", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let type = String(experience.rawValue)
        let name = nameTextField.text
        let email = emailTextField.text
        let shopName = shopNameTextField.text
        let comments = commentTextView.text
        
        var answers = ""
        var typeAnswers = ["","","","","","","",""]
        var answerType: Int?
        
                for i in 0...7 {
        
                    if (nil != (self.selectedDictionary.value(forKey: "\(i)") as? IndexPath)) {
        
                        answerType = (self.selectedDictionary.value(forKey: "\(i)") as? IndexPath)!.row + 1
                        typeAnswers[i] = String(describing: answerType)
                    } else {
                        typeAnswers[i] = "0"
                    }
                }
        
        for type in typeAnswers {
            answers += "\(type),"
        }
        
       answers = answers.substring(to: answers.characters.index(before: answers.endIndex))

        Network.sharedInstance.sumbitExperience(userId, type: type, answers: answers, name: name!, email: email!, shopName: shopName!, comments: comments) { (data) -> Void in
            if (nil != data) {
                let alert = UIAlertController(title: "", message: "Successfully Sent", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Warning", message: "Connection Trouble", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    //MARK: - UITableViewDataSource methods
    
    func tableView( _ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell") as! PositiveNegativeTableViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.customAccessoryView.isHidden = false
        cell.customFilledAccessoryView.isHidden = true
        
        if((self.selectedDictionary.value(forKey: "\(indexPath.section)")) != nil){
            if let item = self.selectedDictionary.value(forKey: "\(indexPath.section)") as? IndexPath{
                if(item == indexPath){
                    cell.customFilledAccessoryView.isHidden = false
                    cell.customAccessoryView.isHidden = true
                }
            }
        }
        
        let answers = self.quiz[indexPath.section]["answers"] as! NSArray
        cell.answerLabel.text = answers[indexPath.row] as? String
        
        return cell
    }
    
    func tableView( _ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return self.quiz[section]["question"] as? String
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clear
            view.textLabel!.textColor = UIColor.white
        }
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let array = self.quiz[section]["answers"] as! NSArray
        return array.count
    }
    
    func numberOfSectionsInTableView( _ tableView: UITableView) -> Int{
        return self.quiz.count
    }
    
    //MARK: - UITableViewDelegate methods
    
    func tableView( _ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(self.selectedDictionary.count != 0){
            if((self.selectedDictionary.value(forKey: "\(indexPath.section)")) != nil){
                if let item = self.selectedDictionary.value(forKey: "\(indexPath.section)") as? IndexPath{
                    if(item == indexPath){
                        self.selectedDictionary.removeObject(forKey: "\(indexPath.section)")
                        
                    }
                    else{
                        self.selectedDictionary.setValue(indexPath, forKey: "\(indexPath.section)")
                    }
                }
            }
            else{
                self.selectedDictionary.setValue(indexPath, forKey: "\(indexPath.section)")
                
            }
        }
        else{
            self.selectedDictionary.setValue(indexPath, forKey: "\(indexPath.section)")
            
        }
        self.tableView.reloadData()
    }
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.selectedTextfieldFrame = textField.frame
        self.changeTableOffset()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if self.commentPlaceholder == textView.text {
            textView.text = ""
        }
        self.selectedTextfieldFrame = textView.frame
        self.changeTableOffset()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if "" == textView.text {
            textView.text = self.commentPlaceholder
        }
        return true
    }
    
    // MARK: - Keyboard Behavior
    
    func onKeyboardFrameChange(_ sender: Notification) {
        
        if let userInfo = sender.userInfo, let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyboardFrame.origin.y < Constants.Size.screenHeight.floatValue {//Keyboard Up
                
                self.tableView.isScrollEnabled = false
                self.keyboardHeight = keyboardFrame.size.height
                self.changeTableOffset()
            } else {//Keyboard Down
                
                self.tableView.isScrollEnabled = true
                self.keyboardHeight = 0
                self.selectedTextfieldFrame = CGRect.zero
                
                let requiredVisibleOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height
                if self.tableView.contentOffset.y > requiredVisibleOffset {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: requiredVisibleOffset), animated: true)
                }
            }
        }
    }
    
    fileprivate func changeTableOffset() {
        
        let statusNavigationBarHeight: CGFloat = 64
        let textfieldYHeight = self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableFooter.bounds.size.height + self.selectedTextfieldFrame.origin.y + self.selectedTextfieldFrame.size.height
        let nonKeyboardHeight = Constants.Size.screenHeight.floatValue - self.keyboardHeight - statusNavigationBarHeight
        if textfieldYHeight - statusNavigationBarHeight > nonKeyboardHeight {
            self.tableView.setContentOffset(CGPoint(x: 0, y: textfieldYHeight + self.tableView.contentOffset.y - nonKeyboardHeight - statusNavigationBarHeight/*textfieldYHeight - nonKeyboardHeight - statusNavigationBarHeight*/ + 10), animated: true)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
