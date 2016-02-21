//
//  ItemStore.swift
//  Homepwner
//
//  Created by Paulo Tanaka on 2/4/16.
//  Copyright © 2016 Paulo Tanaka. All rights reserved.
//

import UIKit


class ItemStore {
  var allItems: [Item] = [Item(name: "No more items", serialNumber: nil, valueInDollars: -1)]

  init() {
    if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
      allItems += archivedItems
    }
  }

  let itemArchiveURL: NSURL = {
    let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    let documentDirectory = documentsDirectories.first!

    return documentDirectory.URLByAppendingPathComponent("items.archive")
  }()

  func createNewItem() -> Item {
    allItems.insert(Item(random: true), atIndex: allItems.count-1)
    return allItems.last!
  }

  func removeItem(item: Item) {
    if let index = allItems.indexOf(item) where index != allItems.count-1 {
      allItems.removeAtIndex(index)
    }
  }

  func canDelete(index: Int) -> Bool {
    return index < allItems.count-1
  }

  func moveItem(fromIndex: Int, toIndex: Int) {
    if fromIndex == toIndex || toIndex == allItems.count-1 || fromIndex == allItems.count-1 {
      return
    }

    let movedItem = allItems[fromIndex]

    allItems.removeAtIndex(fromIndex)

    allItems.insert(movedItem, atIndex: toIndex)
  }

  func saveChanges() -> Bool {
    print("Saving items to: \(itemArchiveURL.path!)")
    return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
  }
}