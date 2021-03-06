//
//  HomeViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos
import Lottie
import FSPagerView
import SnapKit

let WatchDuplicateViewButton: UIButton = {
    let WatchDuplicateButton = UIButton()
    WatchDuplicateButton.backgroundColor = .purple
    return WatchDuplicateButton
}()

class HomeViewController: UIViewController {
    
    let filemg = FileManager.default
    
    private let topAnimationView: AnimationView = {
        var topAnimationView = AnimationView()
        topAnimationView = .init(name: "deleteAnimation")
        topAnimationView.play()
        topAnimationView.loopMode = .loop
        topAnimationView.animationSpeed = 1.2
        
        return topAnimationView
    }()
    
    private let imageController: FSPagerView = {
        var imageConroller = FSPagerView()
        imageConroller.transformer = FSPagerViewTransformer(type: .zoomOut)
        imageConroller.isInfinite = true
        imageConroller.contentMode = .scaleAspectFill
        return imageConroller
    }()
   
    
    private let WatchDuplicateButton: UIButton = {
        let WatchDuplicateButton = UIButton()
        WatchDuplicateButton.setImage(representImage, for: .normal)
        return WatchDuplicateButton
    }()
    
    private let getRootURL: UIButton = {
        let getRootURL = UIButton()
//        getRootURL.backgroundColor = .white
        return getRootURL
    }()
    
    private let chooseFileURL: AnimationView = {
        var chooseFileURL = AnimationView()
        chooseFileURL = .init(name: "findDocuments")
        chooseFileURL.play()
        chooseFileURL.loopMode = .loop
        chooseFileURL.layer.borderWidth = 2
        chooseFileURL.layer.borderColor = UIColor.black.cgColor
//        chooseFileURL.layer.shadowColor = UIColor.gray.cgColor
//        chooseFileURL.layer.shadowRadius = 5
        return chooseFileURL
    }()
    
    private let fileListView: AnimationView = {
        var fileListView = AnimationView()
        fileListView = .init(name: "fileList")
        fileListView.play()
        fileListView.loopMode = .loop
        fileListView.layer.borderColor = UIColor.black.cgColor
        fileListView.layer.borderWidth =  2
        return fileListView
    }()
    
    private let fileListButton: UIButton = {
        let fileListButton = UIButton()
//        fileListButton.backgroundColor = .white
        return fileListButton
    }()
    
  
    private let FileViewButton: UIButton = {
        let FileViewButton = UIButton()
        FileViewButton.backgroundColor = .systemPink
        return FileViewButton
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(WatchDuplicateButton)
//        view.addSubview(WatchDuplicateViewButton)
        
//        view.addSubview(FileViewButton)
        
        // ??????????????? ?????? ?????? ????????????
        chooseFileURL.backgroundBehavior = .pauseAndRestore
        view.addSubview(chooseFileURL)
        view.addSubview(getRootURL)
 
        
        imageController.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "photoCell")
        imageController.delegate = self
        imageController.dataSource = self
        view.addSubview(imageController)
        
//
//        WatchDuplicateButton.addTarget(self, action: #selector(WatchDuplicateButtonTapped), for: .touchUpInside)
//
//        WatchDuplicateViewButton.addTarget(self, action: #selector(WatchDuplicateViewButtonTapped), for: .touchUpInside)
        
        FileViewButton.addTarget(self, action: #selector(FileViewButtonTapped), for: .touchUpInside)
        getRootURL.addTarget(self, action: #selector(getRootURLTapped), for: .touchUpInside)
        
        
        
        
        // ????????????????????? ?????? ????????? ???????????? ?????? ?????? ?????? ??????
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        registerPhotoLibrary()
        
        
        
        fileListView.backgroundBehavior = .pauseAndRestore
        view.addSubview(fileListView)
        view.addSubview(fileListButton)

        fileListButton.addTarget(self, action: #selector(fileListButtonTapped), for: .touchUpInside)
        
        topAnimationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(topAnimationView)
        
        let notificationCenter2 = NotificationCenter.default
        notificationCenter2.addObserver(self, selector: #selector(imageControllerUpdate), name: InfoUpdateNoti, object: nil)
        

    }
    
    @objc func imageControllerUpdate() {
        imageController.reloadData()
    }
    
    @objc func appCameToForeground() {
        
        OperationQueue.main.addOperation {
            reqeustsPhotoPermission()
            
            guard let asset: PHAsset = fetchResult?.object(at: 0) else {
                return
            }
            
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
                
                representImage2 = image!
                
            }
            
            self.imageController.reloadData()
            
            
        }
        
        
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topAnimationView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        imageController.snp.makeConstraints { (make) in
            make.top.equalTo(topAnimationView).offset(80)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.bottom.equalTo(-self.view.frame.height/2)
        }
        
        fileListButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageController.snp.bottom).offset(20)
            make.right.equalTo(imageController)
            make.left.equalTo(imageController)
            make.bottom.equalTo(-self.view.frame.height/3)
        }
        
        fileListView.frame = fileListButton.frame
        
        chooseFileURL.snp.makeConstraints { (make) in
            make.top.equalTo(fileListButton.snp.bottom).offset(20)
            make.right.equalTo(imageController)
            make.left.equalTo(imageController)
            make.bottom.equalTo(-50)
        }
        
        getRootURL.frame = chooseFileURL.frame
        
        
    }
    
    
    @objc private func WatchDuplicateViewButtonTapped() {
        moveView(viewName: "DuplicateImageView")
    }
    
    @objc private func WatchDuplicateButtonTapped() {
        moveView(viewName: "DuplicateView")
    }
    
    @objc private func fileListButtonTapped() {
        print(2)
        let documentPikcer = UIDocumentPickerViewController(forOpeningContentTypes: [.content])
        documentPikcer.shouldShowFileExtensions = true
        documentPikcer.allowsMultipleSelection = true 
        self.present(documentPikcer, animated: true, completion: nil)
    }
    
    @objc private func getRootURLTapped() {
        print(1)
        
        let alert = UIAlertController(title: "", message: "????????? ????????? ???????????? ?????? ????????? ??????????????????", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "??????", style: .default, handler: { _ in
            let documentPikcer = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
            documentPikcer.delegate = self
            documentPikcer.shouldShowFileExtensions = true
            self.present(documentPikcer, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "??????", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
//        let documentPikcer = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
//        documentPikcer.delegate = self
//        documentPikcer.shouldShowFileExtensions = true
////        documentPikcer.allowsMultipleSelection = true
//        present(documentPikcer, animated: true, completion: nil)
        
    }
    
    @objc private func FileViewButtonTapped() {
        moveView(viewName: "DuplicateFileView")
    }
    
    
    private func moveView(viewName: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewName)
        vc?.modalTransitionStyle = .coverVertical
        present(vc!, animated: true, completion: nil)
        
    }
    
    private func getData(fileUrl: URL) {
        
        // ?????? ??? ?????? ?????? ??????
        
        guard fileUrl.startAccessingSecurityScopedResource() else {
            print(fileUrl.lastPathComponent)
            return
            
        }
        
        
        do {
            
            
            let contensts = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
            
            for content in contensts {
                
                
                
                // ?????? ?????? ?????? ?????? ????????? ??????
                do {
                    
                    
                    let conts = try filemg.contentsOfDirectory(at: content, includingPropertiesForKeys: nil)
                    
                    for cont in conts {
                        
                        
                        
                        if let item = filemg.contents(atPath: cont.path) {
                            let fileData = File(url: cont, data: item)
                            
                            if !fileURLLists.contains(fileData.data) {
                                
                                fileURLLists.append(fileData.data)
                                let empty: [URL] = []
                                duplicateFileLists[fileData.data] = empty
                            } else {
                                
                                var urlLists: [URL] = duplicateFileLists[fileData.data]!
                                
                                if urlLists.count == 0 {
                                    duplicateFileData.append(fileData.data)
                                }
                                urlLists.append(fileData.url)
                                duplicateFileLists[fileData.data] = urlLists
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                } catch {
                    print(error)
                    print(2)
                }
                
                
                
                if let item = filemg.contents(atPath: content.path) {
                    let fileData = File(url: content, data: item)
                    
                    if !fileURLLists.contains(fileData.data) {
                        
                        fileURLLists.append(fileData.data)
                        let empty: [URL] = []
                        duplicateFileLists[fileData.data] = empty
                    } else {
                        
                        var urlLists: [URL] = duplicateFileLists[fileData.data]!
                        
                        if urlLists.count == 0 {
                            duplicateFileData.append(fileData.data)
                        }
                        urlLists.append(fileData.url)
                        duplicateFileLists[fileData.data] = urlLists
                        
                    }
                    
                }
                
            }
            
            
            
        } catch {
            print(error)
        }
        
        //            print(duplicateFileLists)
        
        
        // ?????? ?????? ?????? ??????
        
//
//
//        do {
//
//            let contents = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
//
//            if contents.isEmpty {
//                try filemg.removeItem(at: fileUrl)
//            }
//
//        } catch {
//            do {
//                try filemg.removeItem(at: fileUrl)
//            } catch{
//                print("nonono")
//            }
//
//        }
        
   
    }
    

    
}



extension HomeViewController: PHPhotoLibraryChangeObserver {

    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = fetchResult, let changes = changeInstance.changeDetails(for: asset) else {
            return
        }

        fetchResult = changes.fetchResultAfterChanges

        OperationQueue.main.addOperation {
            
        }
    }
}


extension HomeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let rootURL = urls.first else {return}
        
//        guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
//        defer {
//            DispatchQueue.main.async {
//                url.stopAccessingSecurityScopedResource()
//            }
//        }
//
//        do {
//            let document = try Data(contentsOf: url.absoluteURL)
//
//            print("File Selected: " + url.path)
//        }
//        catch {
//            print("Error selecting file: " + error.localizedDescription)
//        }
//
//
//
        
//
//        guard let selectedFileURL = urls.first else {
//            return
//        }
//        let dir = filemg.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
//
//        if filemg.fileExists(atPath: sandboxFileURL.path) {
//            print("already Exists! nothing")
//        }
//        else {
//            do {
//                try filemg.copyItem(at: selectedFileURL, to: sandboxFileURL)
//
//                print("Copied file!")
//            } catch {
//                print("error")
//            }
//        }
        
        
        fileURLLists = [Data]()
        duplicateFileData = [Data]()
        duplicateFileLists = [Data:[URL]]()
            

            
        getData(fileUrl: rootURL)
 

        
        
        moveView(viewName: "DuplicateFileView")
        
    }
    
    

}

extension HomeViewController: FSPagerViewDelegate,FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "photoCell", at: index)
        
        
        
        switch index {
        case 0:
            cell.imageView?.image = representImage
            cell.textLabel?.text = "\(duplicateImageCount)?????? ????????? ?????? ??????"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.backgroundColor = .clear
        default:
            cell.imageView?.image = representImage2
            cell.textLabel?.text = "?????? ?????? ??????"
        }
    
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        switch index {
        case 0:
            moveView(viewName: "DuplicateImageView")
        default:
            moveView(viewName: "DuplicateView")
        }
    }
}
