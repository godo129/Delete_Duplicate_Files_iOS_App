//
//  DuplicateFileViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/06.
//

import UIKit
import Lottie

class DuplicateFileViewController: UIViewController {
    
    private let filemg = FileManager.default
    
    private var collectionView: UICollectionView!
    
    private let emptyAnimaton: AnimationView = {
        var emptyAnimation = AnimationView()
        emptyAnimation = .init(name: "emptyBox")
        emptyAnimation.loopMode = .loop
        emptyAnimation.contentMode = .scaleAspectFit
        emptyAnimation.animationSpeed = 1.2
        emptyAnimation.play()
        return emptyAnimation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // 셀 크기 정하기
        layout.itemSize = CGSize(width: view.frame.size.width/2-2, height: view.frame.size.width/2-2+100)
        // 셀마다 공간 정하기
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.frame = view.bounds
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "fileCell")
        
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
//
//        getData(fileUrl: rootURL)
        
        if duplicateFileData.isEmpty {
            emptyAnimaton.isHidden = false
        } else {
            emptyAnimaton.isHidden = true 
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(emptyAnimaton)
        
        
        

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
                        
                        var urlLists: [URL] = duplicateFileLists[fileData.data]!
                        
                        if urlLists.count == 0 {
                            duplicateFileData.append(fileData.data)
                        }
                        urlLists.append(fileData.url)
                        duplicateFileLists[fileData.data] = urlLists
                        
//                        try filemg.removeItem(at: fileData.url)
//                        print(fileData.url)
//                        print(fileData.data)
//                        
//                        imageView.image = UIImage(data: fileData.data)
                    }
                    
                } else {
                    // 자동으로 하위 디렉토리 정리해줌
                    getData(fileUrl: content)
                }
            }
//
//            print(fileURLLists)
//            print(duplicateFileLists)
            
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyAnimaton.frame = view.bounds
    }
    


}
extension DuplicateFileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return duplicateFileData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fileCell", for: indexPath) as! ImagesCollectionViewCell
        
        cell.ExerciseImage.image = UIImage(data: duplicateFileData[indexPath.row])
        let fileName = duplicateFileLists[duplicateFileData[indexPath.row]]![0].lastPathComponent.description
        cell.ExerciseLabel.text = "\(fileName) \(duplicateFileLists[duplicateFileData[indexPath.row]]!.count)"
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let toDeleteURLs = duplicateFileLists[duplicateFileData[indexPath.row]]!
        
        for toDeleteURL in toDeleteURLs {
            do{
                try filemg.removeItem(at: toDeleteURL)
                
            } catch {
                print("delete errored")
            }
        }
        
        duplicateFileLists.removeValue(forKey: duplicateFileData[indexPath.row])
        
        var empty: [URL] = []
        
        duplicateFileLists[duplicateFileData[indexPath.row]] = empty
        
        duplicateFileData.remove(at: indexPath.row)
        
        
        collectionView.deleteItems(at: [indexPath])
        
        collectionView.reloadData()
        
        if duplicateFileData.isEmpty {
            emptyAnimaton.isHidden = false
        }

    }
    
}
