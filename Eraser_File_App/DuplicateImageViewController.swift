//
//  DuplicateImageViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos
import Lottie

class DuplicateImageViewController: UIViewController {
    
    
    var arrSelectedIndex = [IndexPath]()
    var arrSelectedData = [Data]()

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
    
    private let deleteAllButton: UIButton = {
        let deleteAllButton = UIButton()
        deleteAllButton.setTitle("전부 삭제", for: .normal)
        deleteAllButton.setTitleColor(.black, for: .normal)
        deleteAllButton.backgroundColor = .white
        deleteAllButton.layer.borderWidth = 2
        deleteAllButton.layer.borderColor = UIColor.black.cgColor
        deleteAllButton.layer.cornerRadius = 10
        deleteAllButton.layer.opacity = 0.7
        return deleteAllButton
    }()
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.black.cgColor
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.opacity = 0.7
        return deleteButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPhotoLibrary()
        
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
        
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        view.addSubview(deleteAllButton)
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        if duplicateImageData.isEmpty {
            emptyAnimaton.isHidden = false
            deleteAllButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            emptyAnimaton.isHidden = true
            deleteAllButton.isHidden = false
            deleteButton.isHidden = false
        }
        
        
        collectionView.allowsSelection = true

    }
    
    private func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyAnimaton.frame = view.bounds
        deleteAllButton.frame = CGRect(x: view.frame.width-100, y: 0, width: 100, height: 40)
        deleteButton.frame = CGRect(x: deleteAllButton.frame.origin.x-100, y: 0, width: 100, height: 40)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(emptyAnimaton)
        emptyAnimaton.backgroundBehavior = .pauseAndRestore
        
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reqeustsPhotoPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reqeustsPhotoPermission()
    }
    
    private func imageDataReList() {
        var newDuplicateImageData: [Data] = []
        
        for idx in 0..<duplicateImageData.count/2 {
            duplicateFileLists.removeValue(forKey: duplicateImageData[idx])
        }
        for idx in duplicateImageData.count/2..<duplicateImageData.count {
            newDuplicateImageData.append(duplicateImageData[idx])
        }
        
        duplicateImageData = newDuplicateImageData
    }
    
    @objc private func deleteButtonTapped() {
 
        
            var toDelNum = 0
            var toDelAssets: [PHAsset] = []
            
            for indexPath in self.arrSelectedIndex {
                
                let assets = duplicateLists[duplicateImageData[indexPath.row]]
                
                toDelAssets += assets!
                toDelNum += (assets?.count)!
        
                                    
            }
        
        
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(toDelAssets as NSFastEnumeration)}) { success, error in
                
                
                if success {
                    duplicateImageCount -= toDelNum
                    
                    self.arrSelectedIndex.sort(by: >)
                    
                    for indexPath in self.arrSelectedIndex {
                        
                        
                        
                        duplicateLists.removeValue(forKey: duplicateImageData[indexPath.row])
                        
     
                        OperationQueue.main.addOperation {
                            self.collectionView.cellForItem(at: indexPath)?.isSelected = false
                            self.collectionView.deleteItems(at: [indexPath])
                            self.collectionView.reloadData()
                                            if duplicateImageCount <= 0 {
                                                self.emptyAnimaton.isHidden = false
                                                self.deleteAllButton.isHidden = true
                                                self.deleteButton.isHidden = true
                                                representImage = UIImage(named: "defaultImage")!
                                            } else {
                        
                                                representImage = UIImage(data: duplicateImageData.first!)!
                                            }
                        
                        
                                        }
                    }
                    
                    for indexPath in self.arrSelectedIndex {
                        
                        let data = duplicateImageData[indexPath.row]
                        duplicateImageData = duplicateImageData.filter{$0 != data}
                    }
                    
                    self.arrSelectedData.removeAll()
                    self.arrSelectedIndex.removeAll()
 
                }
            }
            
            
        
        
        

        
        
        
    }
    
    @objc private func deleteAllButtonTapped() {
        
        var toDelDatum: [PHAsset] = []
    
        
        for datum in duplicateImageData {
            
           
            guard let assets = duplicateLists[datum] else {return}
            
            
            toDelDatum += assets
     
        }
        
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(toDelDatum as NSFastEnumeration)}) { success, error in
            if success {
                
                duplicateImageCount = 0
                
                representImage = UIImage(named: "defaultImage")!
                
       
                duplicateImageData.removeAll()
                duplicateLists.removeAll()
                

                OperationQueue.main.addOperation {
                    self.collectionView.removeFromSuperview()
                    self.deleteAllButton.isHidden = true
                    self.emptyAnimaton.isHidden = false
                    self.deleteButton.isHidden = true
                }

            }
            
            
        }

    }
    
    
}

extension DuplicateImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return duplicateImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagesCollectionViewCell
        
        if arrSelectedIndex.contains(indexPath) {
            cell.selectedIndicator.isHidden = false
            
        } else {
            cell.selectedIndicator.isHidden = true
        }
        
        cell.ExerciseImage.image = UIImage(data: duplicateImageData[indexPath.row])!
        cell.ExerciseLabel.text = "\(duplicateLists[duplicateImageData[indexPath.row]]!.count)"
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//        let assets = duplicateLists[duplicateImageData[indexPath.row]]
//
//        let toDelNum = assets?.count
//
//        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(assets! as NSFastEnumeration)}) { success, error in
//            if success {
//                duplicateImageCount -= toDelNum!
//                duplicateLists.removeValue(forKey: duplicateImageData[indexPath.row])
//                duplicateImageData.remove(at: indexPath.row)
//
//                OperationQueue.main.addOperation {
//                    collectionView.deleteItems(at: [indexPath])
//                    collectionView.reloadData()
//                    if duplicateImageCount <= 0 {
//                        self.emptyAnimaton.isHidden = false
//                        self.deleteAllButton.isHidden = true
//                        representImage = UIImage(named: "defaultImage")!
//                    } else {
//
//                        representImage = UIImage(data: duplicateImageData.first!)!
//                    }
//
//
//                }
//
//
//            }
//        }
//
//
//
//
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected cell \(indexPath.item)")
        
        let strData = duplicateImageData[indexPath.row]
        
        if arrSelectedIndex.contains(indexPath) {
            arrSelectedIndex = arrSelectedIndex.filter{$0 != indexPath}
            arrSelectedData = arrSelectedData.filter{$0 != strData}
        } else {
            arrSelectedIndex.append(indexPath)
            arrSelectedData.append(strData)
        }
        collectionView.reloadData()
    }
    
    
    
}



extension DuplicateImageViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = fetchResult, let changes = changeInstance.changeDetails(for: asset) else {
            return
        }

        fetchResult = changes.fetchResultAfterChanges

        OperationQueue.main.addOperation {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
}
