//
//  DuplicateImageViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos

class DuplicateImageViewController: UIViewController {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPhotoLibrary()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.frame = view.bounds
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        
        

    }
    
    private func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

}

extension DuplicateImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return duplicateImageData.count/2
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
