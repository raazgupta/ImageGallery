//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Raj Gupta on 24/9/18.
//  Copyright © 2018 SoulfulMachine. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    
    @IBOutlet weak var imageGalleryView: UICollectionView! {
        didSet {
            //imageGalleryView.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    var imageUrlCollection: [(url: URL, aspectRatio: CGFloat)] = [] {
        didSet {
            //collectionView?.reloadData()
        }
    }
    
    let imageCellWidth: CGFloat = 160.0
    
    /*
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
    
        // Configure the cell
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            imageCell.backgroundImageUrl = imageUrlCollection[indexPath.item].url
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCellWidth, height: imageCellWidth * imageUrlCollection[indexPath.item].aspectRatio)
    }

    
    
    //Drop
    /*
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSURL.self, completion: { nsurls in
            if let url = nsurls.first as? URL {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    let urlContents = try? Data(contentsOf: url.imageURL)
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == nsurls.first as? URL {
                            if let image = UIImage(data: imageData){
                                self?.imageUrlCollection.append((url.imageURL, image.size.height/image.size.width))
                                print(self?.imageUrlCollection as Any)
                            }
                        }
                    }
                }
            }
            
        })
    }
    */
    
    // Dragging and Dropping within Collection View
    
    // Drag
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        /*
        if let image = (collectionView?.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell)?.imageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }*/
        print("Entered dragItemsIndexPath")
        let nsUrlItem = imageUrlCollection[indexPath.item].url as NSURL
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: nsUrlItem))
        dragItem.localObject = imageUrlCollection[indexPath.item]
        return [dragItem]
    }
    
    //Drop
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        print (session.canLoadObjects(ofClass: NSURL.self))
        //return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let imageUrlCollectionItem = item.dragItem.localObject as? (url: URL, aspectRatio: CGFloat) {
                    print("Entered local perfromDrop")
                    collectionView.performBatchUpdates({
                        print("Entered batchUpdate")
                        imageUrlCollection.remove(at: sourceIndexPath.item)
                        imageUrlCollection.insert(imageUrlCollectionItem, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
            else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceHolderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    if let url = provider as? URL {
                        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                            let urlContents = try? Data(contentsOf: url.imageURL)
                            DispatchQueue.main.async {
                                if let imageData = urlContents, url == provider as? URL {
                                    if let image = UIImage(data: imageData) {
                                        placeholderContext.commitInsertion(dataSourceUpdates: { inserttionIndexPath in
                                            self?.imageUrlCollection.insert((url.imageURL,image.size.height/image.size.width), at: inserttionIndexPath.item)
                                        })
                                    }
                                }
                                else {
                                    placeholderContext.deletePlaceholder()
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }

}
