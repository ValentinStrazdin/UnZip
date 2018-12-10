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
    
    private var messageDisplayed: Bool = true
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    
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
                messageDisplayed = false
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
            guard !self.messageDisplayed else { return }
            let ac = UIAlertController.init(title: "UnZip", message: "File was successfully unzipped", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel) {_ in
                self.messageDisplayed = true
            })
            self.present(ac, animated: true, completion: nil)
        }
        else {
            guard let image = UIImage.init(contentsOfFile: fileUrl.path) else { return }
            self.imageWidthConstraint.constant = image.size.width
            self.imageHeightConstraint.constant = image.size.height
            self.scrollView.setupImage(image, for: self.imageView)
            self.navigationItem.title = self.document?.fileURL.lastPathComponent
        }
    }
    
    @IBAction func showFileExplorer() {
        let fileExplorer = FileExplorerViewController()
        fileExplorer.canChooseFiles = true //specify whether user is allowed to choose files
        fileExplorer.canChooseDirectories = false //specify whether user is allowed to choose directories
        fileExplorer.allowsMultipleSelection = false //specify whether user is allowed to choose multiple files and/or directories
        fileExplorer.delegate = self
        self.present(fileExplorer, animated: true, completion: nil)
    }
}

extension DocumentViewController: FileExplorerViewControllerDelegate {
    
    func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {
        print("DidFinish")
    }
    
    func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        guard let fileURL = urls.first else { return }
        self.document = UIDocument(fileURL: fileURL)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension DocumentViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollView.centerContents(for: self.imageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
