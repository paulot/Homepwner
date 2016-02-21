//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Paulo Tanaka on 2/4/16.
//  Copyright © 2016 Paulo Tanaka. All rights reserved.
//

import UIKit


class ItemsViewController: UITableViewController {
  var itemStore: ItemStore!
  var imageStore: ImageStore!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    navigationItem.leftBarButtonItem = editButtonItem()
  }

  @IBAction func addNewItem(sender: AnyObject) {
    // Create a new item and add it to the store
    let newItem = itemStore.createNewItem()

    // Figure out where that item is in the array
    if let index = itemStore.allItems.indexOf(newItem) {
      let indexPath = NSIndexPath(forRow: index-1, inSection: 0)

      // Insert this new row into the table
      tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 65
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemStore.allItems.count
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    // If the table view is asking for the delete command
    if editingStyle == .Delete && itemStore.canDelete(indexPath.row){
      let item = itemStore.allItems[indexPath.row]

      let title = "Delete \(item.name)?"
      let message = "Are you sure you want to delete this item?"

      let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      let deleteAction = UIAlertAction(title: "Remove", style: .Destructive, handler: {
        (action) -> Void in
          // Remove the item from the store
          self.itemStore.removeItem(item)

          self.imageStore.deleteImageForKey(item.itemKey)

          // Also remove that row from the table view with an animation
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        })

      ac.addAction(cancelAction)
      ac.addAction(deleteAction)

      presentViewController(ac, animated: true, completion: nil)

    }
  }

  override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    // Update the model
    if sourceIndexPath.row < itemStore.allItems.count-1 && destinationIndexPath.row < itemStore.allItems.count-1 {
      itemStore.moveItem(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row == itemStore.allItems.count-1 {
      return false
    } else {
      return true
    }
  }

  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row == itemStore.allItems.count-1 {
      return false
    } else {
      return true
    }
  }

  override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {

    if (proposedDestinationIndexPath.row != itemStore.allItems.count-1) {
      return proposedDestinationIndexPath
    }
    return sourceIndexPath
  }

  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      // Get a new of recycled cell
      let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell

      // Set the text on the cell with the description of the item
      // that is at the nth index of items, where n = row this cell
      // will appear in on the tableview
      let item = itemStore.allItems[indexPath.row]
      cell.nameLabel.text = item.name
      cell.serialNumberLabel.text = item.serialNumber
      cell.valueLabel.text = "$\(item.valueInDollars)"

      cell.updateLabels()

      return cell
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // If the triggered segue is the "ShowItem" segue
    if segue.identifier == "ShowItem" {
      // Figure out which row was just tapped
      if let row = tableView.indexPathForSelectedRow?.row {
        // Get the item associated with this row and pass it along
        let item = itemStore.allItems[row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.item = item
        detailViewController.imageStore = imageStore
      }
    }
  }

}
