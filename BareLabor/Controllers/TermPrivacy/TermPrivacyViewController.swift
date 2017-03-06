//
//  TermPrivacyViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class TermPrivacyViewController: UIViewController {

    @IBOutlet weak var textView : UITextView?
    var showContent : SettingsButtonTags!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title and show
        self.navigationItem.title = "Need A Tire"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        if let item = SettingsButtonTags(rawValue: self.showContent.rawValue){
            
            var path = ""
            let bundle = Bundle.main
            switch item {
            case .privacyPolicy :
                self.navigationItem.title = "Privacy Policy"
                path = bundle.path(forResource: "Privacy Policy", ofType: "txt")!
                do {
                    let strPrivacy = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as NSString
                    
                    let fontSize : CGFloat = 14.0
                    let subAttrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSForegroundColorAttributeName : UIColor.white]
                    let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize), NSForegroundColorAttributeName : UIColor.white]
                    let attributedString = NSMutableAttributedString(string: strPrivacy as String, attributes: attrs )
                    
                    
                    let range : NSRange = strPrivacy.range(of: "Third party applications")
                    let range1 : NSRange = strPrivacy.range(of: "Location data")
                    
                    
                    attributedString.addAttributes(subAttrs, range: range)
                    attributedString.addAttributes(subAttrs, range: range1)
                    
                    self.textView?.attributedText = attributedString
                }
                catch {/* error handling here */}
            case .termOfUse :
                do {
                    self.navigationItem.title = "Term Of Use"
                    path = bundle.path(forResource: "Term of use", ofType: "txt")!
                    let strPrivacy = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as NSString
                    
                    let fontSize : CGFloat = 14.0
                    let subAttrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSForegroundColorAttributeName : UIColor.white]
                    let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize), NSForegroundColorAttributeName : UIColor.white]
                    let attributedString = NSMutableAttributedString(string: strPrivacy as String, attributes: attrs )
                    
                    
                    let range : NSRange = strPrivacy.range(of: "Effective Date: May 28, 2015")
                    let range1 : NSRange = strPrivacy.range(of: "1. Your relationship with BareLabor")
                    let range2 : NSRange = strPrivacy.range(of: "2. Accepting this Agreement")
                    let range3 : NSRange = strPrivacy.range(of: "3. Provision of the Services by BareLabor")
                    let range4 : NSRange = strPrivacy.range(of: "4. Use of the Services by you")
                    let range5 : NSRange = strPrivacy.range(of: "5. Your passwords and account security")
                    let range6 : NSRange = strPrivacy.range(of: "6. Privacy and your personal information")
                    let range7 : NSRange = strPrivacy.range(of: "7. Content in the Services")
                    let range8 : NSRange = strPrivacy.range(of: "8. BareLabor Pic Your Price")
                    let range9 : NSRange = strPrivacy.range(of: "Step 1: Where Will You be Coming from?")
                    let range10 : NSRange = strPrivacy.range(of: "Step 2: What Vehicle Needs to be Serviced?")
                    let range11 : NSRange = strPrivacy.range(of: "Step 3: Do You Know What Service You Need?")
                    let range12 : NSRange = strPrivacy.range(of: "9. BareLabor Pic Your Price Service")
                    let range13 : NSRange = strPrivacy.range(of: "10. Proprietary rights")
                    let range14 : NSRange = strPrivacy.range(of: "11. Content license from you")
                    let range15 : NSRange = strPrivacy.range(of: "12. Termination by BareLabor")
                    let range16 : NSRange = strPrivacy.range(of: "13. EXCLUSION OF WARRANTIES")
                    let range17 : NSRange = strPrivacy.range(of: "14. LIMITATION OF LIABILITY")
                    let range18 : NSRange = strPrivacy.range(of: "15. Indemnification")
                    let range19 : NSRange = strPrivacy.range(of: "16. Dispute Resolution and Class Action Waiver")
                    let range20 : NSRange = strPrivacy.range(of: "17. Copyright policies")
                    let range21 : NSRange = strPrivacy.range(of: "18. Advertisements")
                    let range22 : NSRange = strPrivacy.range(of: "19. Other content")
                    let range23 : NSRange = strPrivacy.range(of: "20. Changes to this Agreement")
                    let range24 : NSRange = strPrivacy.range(of: "21. General legal terms")
                    
                    attributedString.addAttributes(subAttrs, range: range)
                    attributedString.addAttributes(subAttrs, range: range1)
                    attributedString.addAttributes(subAttrs, range: range2)
                    attributedString.addAttributes(subAttrs, range: range3)
                    attributedString.addAttributes(subAttrs, range: range4)
                    attributedString.addAttributes(subAttrs, range: range5)
                    attributedString.addAttributes(subAttrs, range: range6)
                    attributedString.addAttributes(subAttrs, range: range7)
                    attributedString.addAttributes(subAttrs, range: range8)
                    attributedString.addAttributes(subAttrs, range: range9)
                    attributedString.addAttributes(subAttrs, range: range10)
                    attributedString.addAttributes(subAttrs, range: range11)
                    attributedString.addAttributes(subAttrs, range: range12)
                    attributedString.addAttributes(subAttrs, range: range13)
                    attributedString.addAttributes(subAttrs, range: range14)
                    attributedString.addAttributes(subAttrs, range: range15)
                    attributedString.addAttributes(subAttrs, range: range16)
                    attributedString.addAttributes(subAttrs, range: range17)
                    attributedString.addAttributes(subAttrs, range: range18)
                    attributedString.addAttributes(subAttrs, range: range19)
                    attributedString.addAttributes(subAttrs, range: range20)
                    attributedString.addAttributes(subAttrs, range: range21)
                    attributedString.addAttributes(subAttrs, range: range22)
                    attributedString.addAttributes(subAttrs, range: range23)
                    attributedString.addAttributes(subAttrs, range: range24)
                    
                    
                    self.textView?.attributedText = attributedString
            }
            catch {/* error handling here */}
            default :
                debugPrint("TermOfUse")
            }
            
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
