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
        getRootURL.backgroundColor = .clear
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
        
        // 백그라운드 갔다 와도 돌아가게
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
        
        
        
        
        // 백그라운드에서 다시 앱으로 돌아오는 것을 알아 채게 하기
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
        
//        topAnimationView.frame = CGRect(x: view.frame.size.width-200, y: 70, width: 300, height: 100)
        
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
        
//        imageController.frame = CGRect(x: 30, y: 150, width: view.frame.width-60, height: 300)
        
//        WatchDuplicateButton.frame = CGRect(x: 30, y: 100, width: view.frame.width-60, height: 300)
////
//        WatchDuplicateViewButton.frame = CGRect(x: 30, y: 600, width: view.frame.width-60, height: 300)
        
//        FileViewButton.frame = CGRect(x: 30, y: 350, width: view.frame.width-260, height: 200)
        
//        fileListButton.frame = CGRect(x: 30, y: chooseFileURL.frame.origin.y-120, width: view.frame.width-60, height: 100)
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
//        chooseFileURL.frame = CGRect(x: 30, y: imageController.frame.origin.y+450, width: view.frame.width-60, height: 250)
//        getRootURL.frame = CGRect(x: FileViewButton.frame.origin.x
//                                    + FileViewButton.frame.width, y: FileViewButton.frame.origin.y, width: 300, height: 200)
        getRootURL.frame = chooseFileURL.frame
        
        
    }
    
    
    @objc private func WatchDuplicateViewButtonTapped() {
        moveView(viewName: "DuplicateImageView")
    }
    
    @objc private func WatchDuplicateButtonTapped() {
        moveView(viewName: "DuplicateView")
    }
    
    @objc private func fileListButtonTapped() {
        let documentPikcer = UIDocumentPickerViewController(forOpeningContentTypes: [.content])
        documentPikcer.shouldShowFileExtensions = true
        documentPikcer.allowsMultipleSelection = true 
        self.present(documentPikcer, animated: true, completion: nil)
    }
    
    @objc private func getRootURLTapped() {
        
        let alert = UIAlertController(title: "", message: "중복된 폴더를 제거하고 싶은 파일을 선택해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            let documentPikcer = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
            documentPikcer.delegate = self
            documentPikcer.shouldShowFileExtensions = true
            self.present(documentPikcer, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
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
        
        // 이걸 해 줘야 접근 가능
        
        guard fileUrl.startAccessingSecurityScopedResource() else {
            print(fileUrl.lastPathComponent)
            return
            
        }
        
        
        do {
            
            
            let contensts = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
            
            for content in contensts {
                
                
                
                // 폴더 안의 폴더 까지 데이터 얻기
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
        
        
        // 매체 없는 파일 삭제
        
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
            cell.textLabel?.text = "\(duplicateImageCount)개의 중복된 사진 존재"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.backgroundColor = .clear
        default:
            cell.imageView?.image = representImage2
            cell.textLabel?.text = "사진 파일 보기"
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
