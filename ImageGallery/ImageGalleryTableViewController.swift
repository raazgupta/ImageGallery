//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Raj Gupta on 30/9/18.
//  Copyright © 2018 SoulfulMachine. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {

    //var imageGalleryTitles: [String] = ["Gallery"]
    //var recentlyDeletedTitles: [String] = []
    
    var imageGalleries: [ImageGalleryModel] = [ImageGalleryModel(title: "Gallery")]
    var recentlyDeletedImageGalleries: [ImageGalleryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && recentlyDeletedImageGalleries.count > 0 {
            return "Recently Deleted"
        }
        else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return imageGalleries.count
        case 1:
            return recentlyDeletedImageGalleries.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryNameCell", for: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = imageGalleries[indexPath.row].galleryTitle
        case 1:
            cell.textLabel?.text = recentlyDeletedImageGalleries[indexPath.row].galleryTitle
        default:
            break
        }
        

        return cell
    }
    
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        //imageGalleryTitles += ["Gallery".madeUnique(withRespectTo: imageGalleryTitles)]
        imageGalleries += [ImageGalleryModel(title: "Gallery".madeUnique(withRespectTo: imageGalleries.map({
            $0.galleryTitle
        })))]
        tableView.insertRows(at: [IndexPath(row: imageGalleries.count - 1, section: 0)], with: .left)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.performBatchUpdates({
                if indexPath.section == 0 {
                    let deletedImageGallery = imageGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    recentlyDeletedImageGalleries += [deletedImageGallery]
                    tableView.insertRows(at: [IndexPath(row: recentlyDeletedImageGalleries.count - 1, section: 1)], with: .left)
                }
                else if indexPath.section == 1 {
                    recentlyDeletedImageGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Swipe to the right to un-delete
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undeleteAction = UIContextualAction(style: .destructive, title: "Restore", handler: {_,_,_ in
                tableView.performBatchUpdates({
                        let deletedImageGallery = self.recentlyDeletedImageGalleries.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.imageGalleries += [deletedImageGallery]
                        tableView.insertRows(at: [IndexPath(row: self.imageGalleries.count - 1, section: 0)], with: .left)
                        //tableView.reloadSections(IndexSet(integersIn: 0...1), with: .fade)
                        tableView.reloadData()
                })
            })
            return UISwipeActionsConfiguration(actions: [undeleteAction])
        }
        return nil
    }
    
    
    // Segue to the Image Gallery Collection View by tapping on Table cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailImageGallery" {
            if let imageGalleryCVC = segue.destination.contents as? ImageGalleryCollectionViewController {
                if let imageGalleryIndex = tableView.indexPathForSelectedRow {
                    imageGalleryCVC.imageGallery = imageGalleries[imageGalleryIndex.row]
                }
            }
        }
    }
    
    // Do not allow recently deleted rows to Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.indexPathForSelectedRow?.section == 1 && identifier == "showDetailImageGallery" {
            return false
        }
        return true
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
