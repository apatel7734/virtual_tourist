//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 5/31/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    var myAnnotation: MyAnnotation?
    var totalPages = 1
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let annotation = myAnnotation{
            mapView.addAnnotation(annotation)
            mapView.centerCoordinate = annotation.coordinate
            
            //disable button
            newCollectionBtn.enabled = false
            
            //get photos for location
            var lat = "\(annotation.coordinate.latitude)"
            var lng = "\(annotation.coordinate.longitude)"
            if(myAnnotation?.pin?.photos.count > 0 ){
                //photos are available offline. display offline picture.
                newCollectionBtn.enabled = true
            }else{
                //fetch flicker images
                fetchNewFlickrImages(lat, lng: lng)
            }
        }
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
    @IBAction func onNewCollectionClicked(sender: UIButton) {
        if let annotation = myAnnotation{
            newCollectionBtn.enabled = false
            var lat = "\(annotation.coordinate.latitude)"
            var lng = "\(annotation.coordinate.longitude)"
            
            fetchNewFlickrImages(lat, lng: lng)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //layout subviews so its cells take up of 1/3 of width.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        var width = floor(photoCollectionView.frame.size.width/3)
        width = width - 1
        layout.itemSize = CGSize(width: width, height: width)
        photoCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let num = myAnnotation?.pin?.photos.count{
            return num
        }else{
            return 0
        }
    }
    
    func reloadCollectionView(){
        dispatch_async(dispatch_get_main_queue()) {
            self.photoCollectionView.reloadData()
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.newCollectionBtn.enabled = true
        }
    }
    
    
    func clearExistingPhotosfromPin(){
        
        var photosToRemove = myAnnotation?.pin?.photos
        if let photosToRemove = photosToRemove{
            for photo in photosToRemove{
                photo.photoImage = nil
                sharedContext.deleteObject(photo)
            }
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func removePhotoFromPin(index: Int){
        var photoToRemove = myAnnotation?.pin?.photos[index]
        if let photoToRemove = photoToRemove{
            photoToRemove.photoImage = nil
            sharedContext.deleteObject(photoToRemove)
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func fetchAndDisplayFlickrImages(lat: String, lng:String, pageNum: Int){
        FlickerClient.sharedInstance().getPhotosForLocation(lat , lng: lng, pageNum: pageNum) { (photos, error) -> Void in
            if(error == nil){
                
                let newPhotos = photos?.photos
                
                if newPhotos?.count > 0{
                    self.clearExistingPhotosfromPin()
                }
                if let newPhotos = newPhotos{
                    for photo in newPhotos{
                        var photoTobeSaved = Photo(photo: photo as? NSDictionary, context: self.sharedContext)
                        photoTobeSaved.pin = self.myAnnotation?.pin
                    }
                }
                
                if let pages = photos?.pages{
                    self.totalPages = pages
                }
                if let page = photos?.page{
                    self.currentPage = page
                }
                self.reloadCollectionView()
                
                // Save the context
                self.saveContext()
                
            }else{
                //display error alert
                if let description = error?.localizedDescription{
                    self.showAlert("Error!", message: description)
                    self.newCollectionBtn.enabled = false
                }
            }
        }
    }
    
    
    func getNextPageNumber() -> Int{
        var nextPage = currentPage + 1
        if (nextPage <= totalPages) && (nextPage > 0 ){
            return nextPage
        }else{
            return -1;
        }
    }
    
    func fetchNewFlickrImages(lat: String, lng: String){
        newCollectionBtn.enabled = false
        let nextPageNumber = getNextPageNumber()
        if (nextPageNumber >= 0){
            fetchAndDisplayFlickrImages(lat, lng: lng, pageNum: nextPageNumber)
        }else{
            //last page display some message
            showAlert("Empty result returned.", message: "No more images available for this location.")
        }
    }
    
    func showAlert(title: String, message: String){
        var alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        dispatch_async(dispatch_get_main_queue()){
            alertView.show();
        }
    }
    
    //core data convenience
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var selectedPhotoCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCell
        showAlertAction(indexPath)
    }
    
    func showAlertAction(indexPath: NSIndexPath){
        var alert = UIAlertController(title: "delete image.", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        //OK button
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
                
            case .Default:
                self.removePhotoFromPin(indexPath.row)
                self.reloadCollectionView()
                
            case .Cancel:
                println("Cancel Case")
            case .Destructive:
                println("Destructive Case")
            }
        }))
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
        
        var photo = self.myAnnotation?.pin?.photos[ip.row]
        cell.progressView.hidden = false
        cell.photoImgView.image = nil
        
        if let photo = photo{
            if(photo.photoImage != nil){
                cell.photoImgView.image = photo.photoImage
                cell.progressView.hidden = true
            }else{
                
                var photoUrl = ImageConfig.sharedInstance().getPhotoUrl(photo)
                
                if let photoUrl = photoUrl{
                    var photoNSURL: NSURL = NSURL(string: photoUrl)!
                    let request: NSURLRequest = NSURLRequest(URL: photoNSURL)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            var photoImage = UIImage(data: data);
                            //cache image.
                            photo.photoImage = photoImage
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                cell.photoImgView.image = photoImage
                                cell.progressView.hidden = true
                            }
                        }else{
                            //error downloading images.
                        }
                    })
                }
            }
        }
    }
    
    
}
