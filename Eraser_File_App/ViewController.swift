//
//  ViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos



class ViewController: UIViewController {
    

    var arrSelectedIndex = [IndexPath]()
    var arrSelectedData = [PHAsset]()
    
    let tableView = UITableView()
    
    var collectionVeiw: UICollectionView!
    
    let imageView = UIImageView()
    
    let deleteButton = UIButton()
    
    private let deleteAllButton: UIButton = {
        let deleteAllButton = UIButton()
        deleteAllButton.setTitle("삭제", for: .normal)
        deleteAllButton.setTitleColor(.black, for: .normal)
        deleteAllButton.backgroundColor = .white
        deleteAllButton.layer.borderWidth = 2
        deleteAllButton.layer.borderColor = UIColor.black.cgColor
        deleteAllButton.layer.cornerRadius = 10
        deleteAllButton.layer.opacity = 0.7
        return deleteAllButton
    }()
    
    
    
//
//    let layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 150, height: 150)
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        return layout
//    }()
//
//    let cells = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
//
    
    
    // 썸네일 만들기
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 초기화
        duplicateLists = [:]
        duplicateImageData = []
        imageDataList = []
        
        reqeustsPhotoPermission()
        
        deleteButton.backgroundColor = .systemRed
        

   
//        cells.dataSource = self
//        cells.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        cells.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        
       // view.addSubview(tableView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // 셀 크기 정하기
        layout.itemSize = CGSize(width: view.frame.size.width/2-1, height: view.frame.size.width/2-2+100)
        // 셀마다 공간 정하기
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionVeiw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVeiw.backgroundColor = .white
        
        view.addSubview(collectionVeiw)
        collectionVeiw.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionVeiw.dataSource = self
        collectionVeiw.delegate = self
        collectionVeiw.allowsMultipleSelection = true
        
        
        view.addSubview(imageView)
        
 
        //view.addSubview(cells)
        
        
        registerPhotoLibrary()
        
        print(duplicateImageData)
        print(duplicateLists)
        
        view.addSubview(deleteAllButton)
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: InfoUpdateNoti, object: nil)
    }
    
    @objc private func deleteAllButtonTapped() {
      
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(self.arrSelectedData as NSFastEnumeration)}) { success, error in
                    if success {
        
                        OperationQueue.main.addOperation {
                            reqeustsPhotoPermission()
                            representImage = UIImage(named: "defaultImage")!
                            self.collectionVeiw.reloadData()
        
                            guard let asset: PHAsset = fetchResult?.object(at: 0) else {
                                return
                            }
                            
                            self.arrSelectedIndex.sort(by: >)
                            
                            for index in self.arrSelectedIndex {
                                self.collectionVeiw.cellForItem(at: index)?.isSelected = false
                            }
                            
                            self.arrSelectedIndex.removeAll()
                            self.arrSelectedData.removeAll()

                            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
        
                                representImage2 = image!
        
                            }
                        }
        
                    }
        
        
                }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        imageView.frame = CGRect(x: 200, y: 200, width: 300, height: 300)
        collectionVeiw.frame = view.bounds
        
        deleteAllButton.frame = CGRect(x: view.frame.width-100, y: 0, width: 100, height: 40)
        
    }
    

}




extension ViewController: PHPhotoLibraryChangeObserver {

    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = fetchResult, let changes = changeInstance.changeDetails(for: asset) else {
            return
        }

        fetchResult = changes.fetchResultAfterChanges

        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
            self.collectionVeiw.reloadSections(IndexSet(0...0))
        }
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImagesCollectionViewCell
        guard let asset: PHAsset = fetchResult?.object(at: indexPath.row) else {
            return cell
        }
        
        if arrSelectedIndex.contains(indexPath) {
            cell.selectedIndicator.isHidden = false
            
        } else {
            cell.selectedIndicator.isHidden = true
        }
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
            cell.ExerciseImage.image = image
            cell.ExerciseLabel.isHidden = true
            cell.CountLabel.isHidden = true 
        }
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let asset = fetchResult?[indexPath.row]
//        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)}) { success, error in
//            if success {
//
//                OperationQueue.main.addOperation {
//                    reqeustsPhotoPermission()
//                    representImage = UIImage(named: "defaultImage")!
//                    self.collectionVeiw.reloadData()
//
//                    guard let asset: PHAsset = fetchResult?.object(at: 0) else {
//                        return
//                    }
//
//
//                    self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
//
//                        representImage2 = image!
//
//                    }
//                }
//
//            }
//
//
//        }
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected cell \(indexPath.item)")
        
        let strData = fetchResult[indexPath.row]
        
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
