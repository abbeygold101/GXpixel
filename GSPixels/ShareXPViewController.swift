//
//  ShareXPViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 26/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

class ShareXPViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var desccriptionTextView: UITextView!
    var imgName = "none"
    var alert: UIAlertController?
    var loadingIndicator: UIActivityIndicatorView?
    var name = String()
    var location = String()
    var shortDescription = String()
    let sanitizer = StringSanitizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        desccriptionTextView.delegate = self
        alert = UIAlertController(title: nil, message: "Uploading, Please wait...", preferredStyle: .alert)
        
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator?.startAnimating();
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func EndEditing(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func saveXP(_ sender: Any) {
        if (desccriptionTextView.text?.isEmpty)! {
            showAlert(title:"Error", message: "Please Enter photo description")
        }
        else if (locationTextField.text?.isEmpty)! {
            showAlert(title:"Error", message: "Please Enter location where picture was taken")
        }
        else if (nameTextField.text?.isEmpty)! {
            showAlert(title:"Error", message: "Please Enter your name")
        }
        else if (photoImageView.image == #imageLiteral(resourceName: "defaultPhoto-1")){
            showAlert(title:"Error", message: "You haven't uploaded any picture yet, please tap on image to select a picture")
        }
        
        else{
            name = sanitizer.cleanString(this: nameTextField.text!)
            location = sanitizer.cleanString(this: locationTextField.text!)
            shortDescription = sanitizer.cleanString(this: desccriptionTextView.text)
            
            alert?.view.addSubview(loadingIndicator!)
            present(alert!, animated: true, completion: nil)
            uploadImage()
        }
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func uploadImage(){
        let url = NSURL(string: "http://www.31stbridge.com/godson_project/appUploads/uploadfromapp.php")
        
        var request = URLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        

        let timeStamp = Date().timestamp.description
        let sanitizedName = name.folding(options: .diacriticInsensitive, locale: nil)
        let uploader = sanitizedName.replacingOccurrences(of: " ", with: "")
        imgName = uploader + timeStamp + ".jpg"
        
        let image_date = UIImageJPEGRepresentation(photoImageView.image!, 0.5)
        //let image_data = UIImageJPEGRepresentation(compressImaged!)
        
        let body = NSMutableData()
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"photo\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("Incoming\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(imgName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using:
            String.Encoding.utf8)!)
        body.append(image_date!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using:
            String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response , error
                == nil else {
                    print("error")
                    return
            }
            self.createEntry()
        }
        task.resume()
    }
    
    func createEntry(){
        //created URL
        let requestURL = URL(string: "http://www.31stbridge.com/godson_project/appUploads/poststory.php")
        
        //creating URLRequest
        var request = URLRequest(url: requestURL!)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "location=\(location)&comment=\(shortDescription)&credit=\(name)&imageurl=\(imgName)"
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: .utf8)
        
        //creating a task to send the post request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                print("error is \(error!.localizedDescription)")
                return
            }
            
            guard let _ = data else {
                print("No data was returned by the request!")
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: false, completion: nil)
                self.dismiss(animated: false, completion: nil)
            }
            
        }
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxCharacter: Int = 140
        return (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= maxCharacter
    }

}

extension Date {
    var timestamp: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}


