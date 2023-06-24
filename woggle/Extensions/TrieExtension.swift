//
//  TrieExtension.swift
//  wuggleCoreData
//
//  Created by sparkes on 2023/06/22.
//

import Foundation
import CoreData
import UIKit


extension TrieNode  {
  func getChildVals() -> String {
    
    var vals = ""
    let children = self.children?.allObjects as! [TrieNode]
    
    for child in children {
      vals += child.value!
    }
    
    return vals
    }
  
  func getChild(val: String) -> TrieNode? {
    // Return child of current node with specified value.
    // Else, return nil
    
    var child:TrieNode?
    
    let children = self.children?.allObjects as! [TrieNode]
    for c in children {
      if c.value == val {
        child = c
        break
      }
    }
    
    return child
  }
  
  func getParent() -> TrieNode? {
    return self.parent
  }
  
  func moveToChild(value: String, context: NSManagedObjectContext) -> TrieNode? {
    // Either getChild is present, or create a child.
    
    var child = self.getChild(val: value)
    if child == nil {
      child = TrieNode(context: context)
      child!.value = value
      child!.parent = self
    }
    return child
    
  }
  
  func goToRoot() -> TrieNode? {
    // Root has no parent, so keep moving back.
    // If loop is introduced, this breaks.
    var currentNode = self
    while (currentNode.parent != nil) {
      currentNode = currentNode.parent!
    }
    return currentNode
  }
  
  func addWord(word: String, context: NSManagedObjectContext) {
    // Safely add a word.
    // Got to root, then use moveToChild, which creates child if needed.
    guard !word.isEmpty else { return }
    let lword = word.lowercased()
    
    var node = self
    if self.parent != nil {
      node = self.goToRoot()!
    }
    for char in lword {
      node = node.moveToChild(value: String(char), context: context)!
    }
    node.word = true
  }
  
  func memoryContainsWord(word: String, lexicon: Int) -> Bool {
    return false
  }
  
  func memoryGoTo(word: String) -> TrieNode? {
    return nil
  }
  
  func getChildren() -> Set<TrieNode> {
    let s = Set<TrieNode>()
    return s
  }
  
  func getValue() -> String {
    return self.value!
  }
  
  func completeTrieFromFile(fName: String, context: NSManagedObjectContext) {
    
    if let path = Bundle.main.path(forResource: fName, ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let myStrings = data.components(separatedBy: .newlines)
        for word in myStrings {
          self.addWord(word: word, context: context)
        }
      } catch {
        print("error")
      }
    }
    
    print("storing")
    do {
      try context.save()
    } catch {
      print("fail")
    }
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    print("trie built using insert")
  }
  

}
