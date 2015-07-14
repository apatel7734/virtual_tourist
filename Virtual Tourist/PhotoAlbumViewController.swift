//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 5/31/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var annotation: MKAnnotation?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    
    var photos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let pin = annotation{
            mapView.addAnnotation(pin)
            mapView.centerCoordinate = pin.coordinate
            
            //get photos for location
            var lat = "\(pin.coordinate.latitude)"
            var lng = "\(pin.coordinate.longitude)"
            FlickerClient.sharedInstance().getPhotosForLocation(lat , lng: lng) { (photos, error) -> Void in
                println("Returned from Completion handler")
                if(error == nil){
                    self.photos = photos?.photos
                    self.photoCollectionView.reloadData()
                }else{
                    
                }
            }
        }
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
    
    @IBAction func onNewCollectionClicked(sender: UIButton) {
        sender.enabled = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //layout subviews so its cells take up of 1/3 of width.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        var width = floor(self.photoCollectionView.frame.size.width/3)
        width = width - 1
        layout.itemSize = CGSize(width: width, height: width)
        self.photoCollectionView.collectionViewLayout = layout
    }
    
    //MARK - collection view delegates
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let num = photos?.count {
            return num
        }else{
            return 10
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("photocell", forIndexPath: indexPath) as! PhotoCell
        
        //configure cell layouts, set data etc here.
        configureCell(photoCell, ip: indexPath)
        
        return photoCell
    }
    
    func configureCell(cell: PhotoCell, ip: NSIndexPath){
        
        //configure progressbar
        cell.progressView.layer.cornerRadius = 5.0
        cell.progressView.backgroundColor = UIColor.darkGrayColor()
        var photo = self.photos?[ip.row]
        var url = getPhotoUrl(photo)
        cell.progressView.hidden = false
        cell.photoImgView.image = nil
        if let imgUrl = url{
            loadImage(imgUrl, imageView: cell.photoImgView, progressView: cell.progressView)
        }
    }
    
    func loadImage(urlString:String,imageView: UIImageView, progressView: UIView){
        var imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                imageView.image = UIImage(data: data)
                progressView.hidden = true
            }
        })
    }
    
    func getPhotoUrl(photo: Photo?) -> String?{
        let farmId = photo?.getFarm()
        let server = photo?.getServer()
        let id = photo?.getId()
        let secret = photo?.getSecret()
        if(farmId !=  nil && server != nil && id != nil && secret != nil){
            var urlStr = "https://farm\(farmId!).staticflickr.com/\(server!)/\(id!)_\(secret!).jpg"
            return urlStr
        }
        return nil
    }
    
}
