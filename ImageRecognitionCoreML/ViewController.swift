//
//  ViewController.swift
//  ImageRecognitionCoreML
//
//  Created by spychatter mx on 11/20/17.
//  Copyright © 2017 spychatter. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	
	private var imagePicker = UIImagePickerController()
	private var model = GoogLeNetPlaces()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.imagePicker.sourceType = .photoLibrary
		self.imagePicker.delegate = self
		
		
	}

	@IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
		present(self.imagePicker, animated: true, completion: nil)
	}
	
	private func processImage(image: UIImage){
		
		guard let ciImage = CIImage(image: image) else{
			fatalError("Unable to create the ciImage object")
		}
		//1 Create a visionModel
		guard let visionModel = try? VNCoreMLModel(for: model.model) else {fatalError("Unable to create model")}
		
		//2 Create a visonRequest
		let visionRequest = VNCoreMLRequest(model: visionModel) { request, error in
			
		}
		
		//3 Create a visionHadler for invoking visionRequest in dispatchQueue.
		let visionHandler = VNImageRequestHandler(cgImage: ciImage as! CGImage, orientation: .up, options: [:])
		
		//4 Separate visionRequest from queue
		DispatchQueue.global(qos: .userInitiated).async {
			 try! visionHandler.perform([visionRequest])
		}
	}
	
	//Keyboard toggle
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
	}
	
}

extension ViewController: UINavigationControllerDelegate{
	
}

extension ViewController: UIImagePickerControllerDelegate{
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		dismiss(animated: true, completion: nil)
		
		guard let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
			return
		}
		
		self.imageView.image = pickerImage
		processImage(image: pickerImage)
		
	}
	
}
