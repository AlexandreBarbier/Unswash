//
//  UnsplashPhotoViewController.swift
//  unsplash_finder
//
//  Created by Alexandre Barbier on 17/11/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import SafariServices

private let minSpace: CGFloat = 16

open class UnswashPhotoViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    var photoDownloader : URLSession!
    let phototDLQueue = OperationQueue()
    var dataSource: [Photo] = []
    var imageList: [String : UIImage] = [:]
    private var isFetching = false
    private var completion:((UIImage, String?) -> Void)?
    private var imageQuality: UnswashImageQuality = .regular


    override open func viewDidLoad() {
        super.viewDidLoad()
        let config = URLSessionConfiguration.default
        phototDLQueue.name = "unswash.photoQueue"
        photoDownloader = URLSession(configuration: config, delegate: nil, delegateQueue: phototDLQueue)
        collectionView.contentInset = UIEdgeInsetsMake(56, 0, 0, 0)
        collectionView.register(UINib(nibName: ImageCollectionViewCell.identifier,
                                      bundle: Bundle(for: ImageCollectionViewCell.self)),
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        requestPhotos()
    }

    private func requestPhotos() {
        let currentPage = Int(dataSource.count / 20) + 1
        isFetching = true
        if let searchText = searchBar.text, searchText != "" {
            Unswash.Photos.search(query: searchText, page: currentPage, per_page: 20, completion: { (photos) in
                self.dataSource = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isFetching = false
                }
            })
        }
        else {
            Unswash.Photos.get(page: currentPage, per_page: 20) { (photos) in
                self.dataSource.append(contentsOf:photos)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isFetching = false
                }
            }
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    open class func picker() -> UnswashPhotoViewController {
        let controller = UnswashPhotoViewController(nibName: "UnswashPhotoViewController", bundle: Bundle(for: UnswashPhotoViewController.self))
        return controller
    }

    open func present(in parent: UIViewController, quality: UnswashImageQuality = .regular,
                      completion: ((_ image: UIImage, _ url: String?) -> Void)? = nil) {
        self.completion = completion
        imageQuality = quality
        parent.present(self, animated: true, completion: nil)
    }

    @IBAction func closeTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func UnsplashTouch(_ sender: Any) {
       let sfVC =  SFSafariViewController(url: URL(string: "https://unsplash.com")!)
        present(sfVC, animated: true, completion: nil)
    }
}

extension UnswashPhotoViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataSource = []
        requestPhotos()
    }

}

extension UnswashPhotoViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (self.view.frame.size.width - (3 * minSpace)) / 2
        return CGSize(width: cellSize, height: cellSize + 30)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, minSpace, 0, minSpace)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minSpace
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = dataSource[indexPath.row].urls!.regular
        completion?(imageList[url]!, url)
        dismiss(animated: true, completion: nil)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataSource.count < 100 && !isFetching,
            let lastVisibleCell = collectionView.visibleCells.last,
            let index = collectionView.indexPath(for: lastVisibleCell), index.row > dataSource.count - 10 {
            requestPhotos()
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier,
                                                      for: indexPath) as! ImageCollectionViewCell
        let photo = self.dataSource[indexPath.row]
        let url = photo.getURLForQuality(quality: imageQuality)
        cell.authorButton.setTitle(photo.user!.name, for: .normal)
        cell.index =  indexPath.row
        cell.delegate = self
        if cell.dataTask != nil {
            cell.dataTask.cancel()
        }
        if imageList[url] == nil {
            let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0)
            cell.dataTask = photoDownloader.dataTask(with: request) { (data, response, error) in
                guard  let data = data, let img = UIImage(data: data) else {
                    return
                }
                self.imageList.updateValue(img, forKey: url)
                DispatchQueue.main.async {
                    cell.imageView.image = img
                }
            }
            cell.dataTask.resume()
        }
        cell.imageView.image = imageList[url]
        return cell
    }
}

extension UnswashPhotoViewController: ImageCollectionViewCellDelegate {
    func authorSelected(index: Int) {
        let user = dataSource[index].user!
        let sfvc = SFSafariViewController(url: URL(string: user.links!.html!)!)
        present(sfvc, animated: true, completion: nil)
    }
}
