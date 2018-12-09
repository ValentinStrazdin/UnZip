//
//  DocumentViewController.swift
//  UnZip
//
//  Created by Valentin Strazdin on 09/12/2018.
//  Copyright © 2018 Valentin Strazdin. All rights reserved.
//

import UIKit
import SSZipArchive

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var document: UIDocument?
    var tempDocumentUrl: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let fileUrl = document?.fileURL else { return }
        if fileUrl.absoluteString.lowercased().hasSuffix(".zip") {
            let folderName = fileUrl.deletingPathExtension().lastPathComponent
            let fileName = "\(folderName).tif"
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let writeUrl = URL(fileURLWithPath: documents).appendingPathComponent(folderName)
            // Unzip
            SSZipArchive.unzipFile(atPath: fileUrl.path, toDestination: writeUrl.path)
            let imageUrl = writeUrl.appendingPathComponent(fileName)
            imageView.image = UIImage.init(contentsOfFile: imageUrl.path)
            self.navigationItem.title = fileName
        }
        else {
            // Access the document
            document?.open(completionHandler: { (success) in
                if success {
                    // Display the content of the document, e.g.:
                    self.imageView.image = UIImage.init(contentsOfFile: fileUrl.path)
                    self.navigationItem.title = self.document?.fileURL.lastPathComponent
                } else {
                    // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
                }
            })
        }
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
