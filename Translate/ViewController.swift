//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

var french = "en|fr"
var irish = "en|ga"
var turkish = "en|tr"
var hindi = "en|hi"
var language = french



class ViewController: UIViewController, UIPickerViewDelegate,  UIPickerViewDataSource {
    
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    var images: [UIImage] = []
    let max = 4
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad(){
        print("viewDidLoad")
        super.viewDidLoad()
        
         var France = UIImage(named: "France")
         var Ireland = UIImage(named: "Ireland")
         var Turkey = UIImage(named: "Turkey")
         var India = UIImage(named: "India")
         images.append(France!)
         images.append(Ireland!)
         images.append(Turkey!)
         images.append(India!)
   
       //CozyLoadingActivity.show("Loading...", sender: self, disableUI: true)
        
    // Connect Data
        self.picker.delegate = self
        self.picker.dataSource = self
    
    //Array Data
    pickerData = ["French", "Gaelic","Turkish","Hindu"]
    }

    //var data = NSMutableData()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //number of cols
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max

    }
    
    //data to return for row and column
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //capture the picker view selection
    func pickerView(pickerView: UIPickerView, var didSelectRow row: Int, inComponent component: Int) {
        print("component: \(component), row: \(row)")
        
        if row == 0{
            language = french
        }
       else if row == 1{
            language = irish
        }
        
        else if row == 2{
            language = turkish
        }
        
        else if row == 3{
            language = hindi
        }


        
        
    }
    
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    //viewForRow
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
    
        print("pickerView")
        var imageView:UIImageView
        
        if(view == nil){
        var image = images [row % 4]
        imageView = UIImageView()
            imageView.image = image;
            imageView.frame = CGRectMake(0,0,30,30)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
        }else{
            imageView = UIImageView()
            
        }
        return imageView
    }
    
  
    @IBAction func translate(sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let langStr = (language).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = NSURL(string: urlStr)
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
        /*let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()*/
        
        CozyLoadingActivity.show("Loading...", sender: self, disableUI: true)
        var result = "<Translation Error>"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
           CozyLoadingActivity.hide(success: true, animated: true)
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                        result = responseData.objectForKey("translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        
    }
}

