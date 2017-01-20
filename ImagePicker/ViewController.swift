//
//  ViewController.swift
//  ImagePicker
//
//  Created by Developer on 1/5/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagesDirectoryPath: String!
    var images: [UIImage]!
    var titles: [String]!
    
    // present the photo library to select the photo
    @IBAction func choosePhoto(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
            creates the bundles 
            access the main directory 
            check if already exits 
                if not create a new folder
        
        */
        images = []
        // returns the bundles / locates the user's documents directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectorPath:String = paths[0]
        
        //creates the path
        imagesDirectoryPath = documentDirectorPath + "/ImagePicker"
        var objecBool : ObjCBool = true
        
        //checks if the file exits already
        let isExit = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objecBool)
        print( (paths[0]))
        // creates a file under imageDirectoryPath
        //print("Working")
        if isExit == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                    print("File created")
            }catch{
                print("Something went wrong while creating folder")
            }
        }
        // pending to review -- new feature to display content in the device
        else{
        do{
            let fileList = try FileManager.default.contentsOfDirectory(atPath: "/")
            for filename in fileList{
                print(filename)
            }
        }catch let error{
            print("Error: \(error.localizedDescription)")
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshTable(){
        do{
            // clean the array of images
            // titles is an array of String
            images.removeAll()
            print("Working")
            // grab of the titles in the folder
            titles = try FileManager.default.contentsOfDirectory(atPath: imagesDirectoryPath)
            for image in titles{
                //
                let data = FileManager.default.contents(atPath: imagesDirectoryPath.appending("/\(image)"))
                //print( (data))
                let image = UIImage(data: data!)
                images.append(image!)
            }
            self.tableView.reloadData()
        }catch{
            print("Error")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController ,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Working")
        // selecting the photo
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            // add the timestamp
            var imagePath = NSDate().description
            // removes all the empty space
            imagePath = imagePath.replacingOccurrences(of: " ", with: "")
            // possible error appending the string
            // build the full path including the unique name + extension
            imagePath = imagesDirectoryPath.appending("/\(imagePath).png")
            // convert image to png representation
            let data = UIImagePNGRepresentation(image)
            // check documemtation for the argument Data vs data
            let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
            
        }
        else{
            print("Something went wrong")
        }
        // reload the view
        /*
         Take photo
         Grab file
         Check if already exits based on the vin number
         Write file into the system
         Load table with all the cars 
         Pass function to dismiss method
         
 */
        dismiss(animated: true, completion: { () -> Void in self.refreshTable()})
    }
    
 
  /*
    func UITableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> UITableViewCell{
        <#code#>
    }
    */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellID")
        cell?.imageView?.image = images[indexPath.row]
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
}
























