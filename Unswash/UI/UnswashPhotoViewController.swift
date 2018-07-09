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
    private var imageQuality: UnswashImageQuality = .small


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
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .default
        }
    }

    private func requestPhotos() {
        let currentPage = Int(dataSource.count / 20) + 1
        isFetching = true
        if let searchText = searchBar.text, searchText != "" {
            Unswash.Photos.search(query: searchText, page: currentPage, per_page: 20, completion: { (photos, errors) in
                guard errors == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.dataSource.append(contentsOf: photos)
                    self.collectionView.reloadData()
                    self.isFetching = false
                }
            })
        }
        else {
            Unswash.Photos.get(page: currentPage, per_page: 20) { (photos, errors) in
                guard errors == nil else {
                    return
                }

                DispatchQueue.main.async {
                    self.dataSource.append(contentsOf:photos)
                    self.collectionView.reloadData()
                    self.isFetching = false
                }
            }
        }
    }

    override open func didReceiveMemoryWarning() {
        imageList.removeAll()
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
        var url = "https://unsplash.com"
            url += "?utm_source=\(Unswash.client.client_name!)&utm_medium=referral&utm_campaign=api-credit"
        let sfVC =  SFSafariViewController(url: URL(string: url)!)
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
        if let url = dataSource[indexPath.row].getURLForQuality(quality: imageQuality), let imageUrl = imageList[url] {
            completion?(imageUrl, url)
            dismiss(animated: true, completion: nil)
        }
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier,
                                                            for: indexPath) as? ImageCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        let photo = dataSource[indexPath.row]
        cell.authorButton.setTitle(photo.user?.name ?? "", for: .normal)
        cell.index = indexPath.row
        cell.delegate = self
        cell.dataTask?.cancel()
        if let url = photo.getURLForQuality(quality: imageQuality) {
            cell.startAnimation()
            if imageList[url] == nil {
                let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0)
                cell.imageView.image = nil

                cell.dataTask = photoDownloader.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        guard
                            let data = data,
                            let img = UIImage(data: data) else {
                            return
                        }
                        self.imageList.updateValue(img, forKey: url)
                        cell.stopAnimation()
                        cell.imageView.image = img
                    }
                }
                cell.dataTask.resume()

            } else {
                cell.stopAnimation()
                cell.imageView.image = imageList[url]
            }
        }
        return cell
    }
}

extension UnswashPhotoViewController: ImageCollectionViewCellDelegate {
    func authorSelected(index: Int) {
        let user = dataSource[index].user!
        var url = "\(user.links!.html!)"
        url += "?utm_source=\(Unswash.client.client_name!)&utm_medium=referral&utm_campaign=api-credit"
        let sfvc = SFSafariViewController(url: URL(string: url)!)
        present(sfvc, animated: true, completion: nil)
    }
}
