//
//  FileViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/05.
//

import UIKit

struct File {
    var url: URL
    var data: Data
}

class FileViewController: UIViewController {

    
    let filemg = FileManager.default
    let path = Bundle.main.resourcePath!
    
    var contentLists: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = "\(UUID().uuidString).txt"
        let contents = "Something happened?"
        
        let dir = filemg.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(file)
        
        do {
            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
        
        let documnetURL = filemg.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        
        getData(fileUrl: documnetURL)
        
     
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
                }
            }
            
            print(contentLists)
            
        } catch {
            print("error ocurred ")
        }
    }


}
