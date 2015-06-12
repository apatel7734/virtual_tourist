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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let pin = annotation{
            println("Pin = \(pin.coordinate.latitude) , \(pin.coordinate.longitude)")
            mapView.addAnnotation(pin)
            mapView.centerCoordinate = pin.coordinate
        }
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        var string = FlickerClient.signRequest()
        println("Base string = \(string)")
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
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("photocell", forIndexPath: indexPath) as! PhotoCell
        
        //configure cell layouts, set data etc here.
        configureCell(photoCell)
        
        return photoCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func configureCell(cell: PhotoCell){
        //configure progressbar
        cell.progressView.layer.cornerRadius = 5.0
        cell.progressView.backgroundColor = UIColor.darkGrayColor()
        //        cell.progressView.hidden = true
    }
    
}
