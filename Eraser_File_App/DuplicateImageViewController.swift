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
        
        registerPhotoLibrary()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // 셀 크기 정하기
        layout.itemSize = CGSize(width: view.frame.size.width/2-2, height: view.frame.size.width/3-4)
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
        
        if duplicateImageData.isEmpty {
            emptyAnimaton.isHidden = false
        } else {
            emptyAnimaton.isHidden = true
        }
        
        print(duplicateLists)
        print(duplicateImageData)

    }
    
    private func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyAnimaton.frame = view.bounds
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(emptyAnimaton)
        
        var newDuplicateImageData: [Data] = []
        
        for idx in 0..<duplicateImageData.count/2 {
            duplicateFileLists.removeValue(forKey: duplicateImageData[idx])
        }
        for idx in duplicateImageData.count/2..<duplicateImageData.count {
            newDuplicateImageData.append(duplicateImageData[idx])
        }
        
        duplicateImageData = newDuplicateImageData
     
    }
    
    
}

extension DuplicateImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return duplicateImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagesCollectionViewCell
        
        cell.ExerciseImage.image = UIImage(data: duplicateImageData[indexPath.row])!
        cell.ExerciseLabel.text = "\(duplicateLists[duplicateImageData[indexPath.row]]!.count)"
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let assets = duplicateLists[duplicateImageData[indexPath.row]]
        
        
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(assets! as NSFastEnumeration)}) { success, error in
            if success {
                duplicateLists.removeValue(forKey: duplicateImageData[indexPath.row])
                duplicateImageData.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
            } else {
                return
            }
        }
        
        collectionView.reloadData()
        
        if duplicateImageData.isEmpty {
            emptyAnimaton.isHidden = false
        }

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
