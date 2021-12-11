//
//  ImagesCollectionViewCell.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    var ExerciseImage: UIImageView = {
            let ExerciseImage = UIImageView()
            ExerciseImage.backgroundColor = .white
            ExerciseImage.clipsToBounds = true
        ExerciseImage.contentMode = .scaleAspectFill
            return ExerciseImage
        }()
        
        var ExerciseLabel: UILabel = {
            let ExerciseLabel = UILabel()
            ExerciseLabel.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
//            ExerciseLabel.backgroundColor = .clear
            ExerciseLabel.textAlignment = .center
            ExerciseLabel.textColor = .black
            ExerciseLabel.font = .systemFont(ofSize: 15, weight: .bold)
            ExerciseLabel.clipsToBounds = true
            ExerciseLabel.layer.masksToBounds = true
            ExerciseLabel.layer.borderWidth = 4
            ExerciseLabel.layer.borderColor = UIColor.black.cgColor
            ExerciseLabel.layer.cornerRadius = ExerciseLabel.bounds.size.width/2
            return ExerciseLabel
            
        }()
    
    var CountLabel: UILabel = {
        let ExerciseLabel = UILabel()
        ExerciseLabel.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
//            ExerciseLabel.backgroundColor = .clear
        ExerciseLabel.textAlignment = .center
        ExerciseLabel.textColor = .black
        ExerciseLabel.font = .systemFont(ofSize: 15, weight: .bold)
        ExerciseLabel.clipsToBounds = true
        ExerciseLabel.layer.masksToBounds = true
        ExerciseLabel.layer.borderWidth = 4
        ExerciseLabel.layer.borderColor = UIColor.black.cgColor
        ExerciseLabel.layer.cornerRadius = ExerciseLabel.bounds.size.width/2
        return ExerciseLabel
        
    }()
    
    var highlightedIndicator: UIView = {
        let highlightedIndicator = UIView()
        return highlightedIndicator
    }()
    
    var selectedIndicator: UIImageView = {
        let selectedIndicator = UIImageView()
        selectedIndicator.image = UIImage(named: "check")
        return selectedIndicator
    }()
    
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .systemRed

            contentView.addSubview(ExerciseImage)
            contentView.addSubview(ExerciseLabel)
            contentView.clipsToBounds = true
            
            contentView.addSubview(selectedIndicator)
            selectedIndicator.isHidden = true

            contentView.addSubview(highlightedIndicator)
            
            contentView.addSubview(CountLabel)
            
        
        }

    override var isHighlighted: Bool {
        didSet {
            highlightedIndicator.isHidden = !isSelected
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightedIndicator.isHidden = !isSelected
            selectedIndicator.isHidden = !isSelected
        }
         
    }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
      
        /*
        func setUpCompo() {
            
            ExerciseLabel = UILabel()
            
            
            ExerciseImage = UIImageView()
            contentView.addSubview(ExerciseImage)
            contentView.addSubview(ExerciseImage)
            ExerciseImage.translatesAutoresizingMaskIntoConstraints = false
            ExerciseImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            ExerciseImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
            ExerciseImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
            ExerciseImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
            
        }
        
        func setUpLabel() {
            ExerciseLabel.font = UIFont.systemFont(ofSize: 20)
            ExerciseLabel.textAlignment = .center
            
        }
     */
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            ExerciseImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
            
//            ExerciseLabel.frame = CGRect(x: contentView.frame.size.width/2+contentView.frame.size.width/4,
//                                         y: contentView.frame.size.height-30,
//                                         width: contentView.frame.size.width/4,
//                                         height: 30)
//            
            ExerciseLabel.frame = CGRect(x: 0,
                                         y: contentView.frame.size.height-30,
                                         width: contentView.frame.size.width,
                                         height: 30)
            
            CountLabel.frame = CGRect(x: contentView.frame.size.width-30, y: 0, width: 30, height: 30)
            
            selectedIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        }
}
