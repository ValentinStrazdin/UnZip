//
//  DocumentViewController.swift
//  UnZip
//
//  Created by Valentin Strazdin on 09/12/2018.
//  Copyright © 2018 Valentin Strazdin. All rights reserved.
//

import UIKit
import SSZipArchive
import FileExplorer

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var document: UIDocument? {
        didSet {
            guard let fileUrl = document?.fileURL else { return }
            if fileUrl.absoluteString.lowercased().hasSuffix(".zip") {
                let folderName = fileUrl.deletingPathExtension().lastPathComponent
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let writeUrl = URL(fileURLWithPath: documents).appendingPathComponent(folderName)
                // Unzip
                SSZipArchive.unzipFile(atPath: fileUrl.path, toDestination: writeUrl.path)
                self.navigationItem.title = folderName
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
    }
    
    /// Here we are loading image file in view or presenting message that file was unzipped
    public func updateView() {
        guard let fileUrl = document?.fileURL else { return }
        if fileUrl.absoluteString.lowercased().hasSuffix(".zip") {
            let ac = UIAlertController.init(title: "UnZip", message: "File was successfully unzipped", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel) {_ in
                self.showFileExplorer()
            })
            self.present(ac, animated: true, completion: nil)
        }
        else {
            self.imageView.image = UIImage.init(contentsOfFile: fileUrl.path)
            self.navigationItem.title = self.document?.fileURL.lastPathComponent
        }
    }
    
    @IBAction func showFileExplorer() {
        let fileExplorer = FileExplorerViewController()
        self.present(fileExplorer, animated: true, completion: nil)
    }
}
