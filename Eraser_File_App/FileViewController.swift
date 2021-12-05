//
//  FileViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/05.
//

import UIKit
import MobileCoreServices

struct File {
    var url: URL
    var data: Data
}

class FileViewController: UIViewController {

    
    let filemg = FileManager.default
    let path = Bundle.main.resourcePath!
    
    let imageView = UIImageView()
    
    var contentLists: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.frame = CGRect(x: 30, y: 50, width: 300, height: 300)
        view.addSubview(imageView)
        
//        let file = "\(UUID().uuidString).txt"
//        let contents = "Something happened?"
//
//        let dir = filemg.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = dir.appendingPathComponent(file)
//
//        do {
//            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
//        } catch {
//            print("Error: \(error)")
//        }
        
        let documnetURL = filemg.urls(for: .documentDirectory, in: .userDomainMask)[0]
        getData(fileUrl: rootURL)
        
        
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
//        documentPicker.directoryURL = documnetURL
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
        
        importFiles()
        
     
    }
    
    private func importFiles() {
        
        let documentPikcer = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPikcer.delegate = self
        present(documentPikcer, animated: true, completion: nil)
        
    }
    
    private func getData(fileUrl: URL) {
        
        print(fileUrl)
        do {
            
            let contensts = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
 
            for content in contensts {
                guard let item = filemg.contents(atPath: content.path) else {return}
                
                let fileData = File(url: content, data: item)
                
                if !contentLists.contains(fileData.data) {
                    contentLists.append(fileData.data)
                } else {
                    
                    try filemg.removeItem(at: fileData.url)
                    print(fileData.url)
                    print(fileData.data)
                    
                    imageView.image = UIImage(data: fileData.data)
                }
            }
            
            print(contentLists)
            
        } catch {
            print("error ocurred ")
        }
    }


}

extension FileViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = filemg.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if filemg.fileExists(atPath: sandboxFileURL.path) {
            print("already Exists! nothing")
        }
        else {
            do {
                try filemg.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                print("Copied file!")
            } catch {
                print("error")
            }
        }
    }
}
