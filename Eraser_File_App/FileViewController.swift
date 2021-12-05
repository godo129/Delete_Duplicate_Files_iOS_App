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
        print(documnetURL)
        getData(fileUrl: rootURL)
        
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
//        documentPicker.directoryURL = documnetURL
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
       
        
    }
    
    
    private func getData(fileUrl: URL) {
        
        
        do {
            
            let contensts = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
 
            for content in contensts {
                if let item = filemg.contents(atPath: content.path) {
                    let fileData = File(url: content, data: item)
                    
                    if !fileURLLists.contains(fileData.data) {
//                        contentLists.append(fileData.data)
                        
                        fileURLLists.append(fileData.data)
                        let empty: [URL] = []
                        duplicateFileLists[fileData.data] = empty
                    } else {
                        
//                        var urlLists: [URL] = duplicateFileLists[fileData.data]!
//                        urlLists.append(fileData.url)
//                        duplicateFileLists[fileData.data] = urlLists
//                        duplicateFileData.append(fileData.data)
                        try filemg.removeItem(at: fileData.url)
                        print(fileData.url)
                        print(fileData.data)
                        
                        imageView.image = UIImage(data: fileData.data)
                    }
                    
                } else {
                    // 자동으로 하위 디렉토리 정리해줌
                    getData(fileUrl: content)
                }
            }

            print(fileURLLists)
            print(duplicateFileLists)
            
        } catch {
            print("error ocurred ")
        }
        
        
        // 매체 없는 파일 삭제
        do {
            
            let contents = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
            
            if contents.isEmpty {
                try filemg.removeItem(at: fileUrl)
            }
            
        } catch {
            do {
                try filemg.removeItem(at: fileUrl)
            } catch{
                print("nonono")
            }
            
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
