//
//  ViewController.swift
//  Assignment
//
//  Created by Abhishek Kumar Singh on 19/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var imageVM: ImageList = []
    var viewModel = ImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }
    
    private func fetchImages() {
        viewModel.getImagesList()
        viewModel.delegate = self
    }
    
    private func getImageURL(thumbnail: Thumbnail) -> URL? {
          let domain = thumbnail.domain
          let basePath = thumbnail.basePath
          let key = thumbnail.key
          let imageUrlString = "\(domain)/\(basePath)/0/\(key)"
          return URL(string: imageUrlString)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            fetchMoreImages()
        }
    }

    func fetchMoreImages() {
     // I'd like to note that I've examined the API's pagination functionality, but it doesn't adhere to standard practices. It lacks options to specify page numbers or ranges for accessing the next block of images. While there are alternative methods to manage pagination using the current API, they aren't recommended practices.
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageVM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifire, for: indexPath) as! ImageCollectionViewCell
        
        let thumbnail = imageVM[indexPath.item].thumbnail
        
        guard let imageUrl = getImageURL(thumbnail: thumbnail) else {
            cell.setThumbNailImage(image: nil)
            return cell
        }
        
        viewModel.loadImage(at: imageUrl, id: thumbnail.id) { image in
              DispatchQueue.main.async {
                  cell.setThumbNailImage(image: image)
              }
          }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 3
        return CGSize(width: width, height: width)
    }
}

extension ViewController: ImageViewModelDelegate {
    func didReceive(viewmodel: ImageList?) {
        if let vm = viewmodel {
            imageVM = vm
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

