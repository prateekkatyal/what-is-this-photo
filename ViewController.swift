//
//  ViewController.swift
//  Detect The Pic
//
//  Created by Prateek Katyal on 12/10/18.
//  Copyright © 2018 Prateek Katyal. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Connecting our TableView

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // View controller created by apple to let user choose an image.
    
    var imagePicker = UIImagePickerController()

    
    // Adding our CoreML Model
    
    var resnetModel = Resnet50()
    
    var results = [VNClassificationObservation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting table view as data source
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let image = imageView.image {
            
            processPicture(image: image)
            
        }
        
        if let image = imageView.image {
            
            processPicture(image: image)
            
        }
        
        imagePicker.delegate = self
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            
            if let image = imageView.image {
                
                processPicture(image: image)
                
            }
            
        }
        
    }
    
    
    // Using the CoreML model to process the picture
    
    func processPicture(image:UIImage) {
        
        if let model = try? VNCoreMLModel(for: resnetModel.model) {
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                
                if let results = request.results as? [VNClassificationObservation] {
                    
                    
                    // Keeping the results to only the first 20
                    
                    self.results = Array(results.prefix(20))
                    
                    // because we are in a completion handler
                    
                    self.tableView.reloadData()
                    
                    
//                    for result in results {
//
//                        print("\(result.identifier) : \(result.confidence * 50)%")
//
//                    }
                    
                }
                
            }
            
            // convert the image
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                
                let handler = VNImageRequestHandler(data: imageData, options: [:] )
                
                try? handler.perform([request])
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Number of rows/cells to show in tableview
        
        return results.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // What data to show in cells?
        
        let cell = UITableViewCell()
        
        let result = results[indexPath.row]
        
        // shortening the text length to 20 so that it fits in properly
        
        let name = result.identifier.prefix(25)
        
        
        cell.textLabel?.text = "\(name) : \(result.confidence * 50)%"
        
        return cell
        
        
    }

    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func photoTapped(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    

}

