//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Raj Gupta on 30/9/18.
//  Copyright © 2018 SoulfulMachine. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {

    var imageGalleryTitles: [String] = ["Gallery"]
    var recentlyDeletedTitles: [String] = []
    
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
        if section == 1 {
            return "Recently Deleted"
        }
        else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return imageGalleryTitles.count
        case 1:
            return recentlyDeletedTitles.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryNameCell", for: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = imageGalleryTitles[indexPath.row]
        case 1:
            cell.textLabel?.text = recentlyDeletedTitles[indexPath.row]
        default:
            break
        }
        

        return cell
    }
    
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        imageGalleryTitles += ["Gallery".madeUnique(withRespectTo: imageGalleryTitles)]
        tableView.insertRows(at: [IndexPath(row: imageGalleryTitles.count - 1, section: 0)], with: .left)
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
                    let deletedImageGalleryTitle = imageGalleryTitles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    recentlyDeletedTitles += [deletedImageGalleryTitle]
                    tableView.insertRows(at: [IndexPath(row: recentlyDeletedTitles.count - 1, section: 1)], with: .left)
                }
                else if indexPath.section == 1 {
                    recentlyDeletedTitles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // Segue to the Image Gallery Collection View by tapping on Table cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailImageGallery" {
            print ("Preparing for Segue")
        }
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
