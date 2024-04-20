//
//  ImageCollectionViewCell.swift
//  Assignment
//
//  Created by Abhishek Kumar Singh on 20/04/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static var identifire:String{
        return String(describing: self)
    }
    
    func setThumbNailImage(image: UIImage?) {
        imageView.image = image ?? UIImage(named: "image_placeholder")
    }
}
