//
//  TrieExtension.swift
//  wuggleCoreData
//
//  Created by sparkes on 2023/06/22.
//

import CoreData


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
    
    var child: TrieNode?
    
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
  
  
  func getRoot() -> TrieNode? {
    // Root has no parent, so keep moving back.
    // If loop is introduced, this breaks.
    var currentNode = self
    while (currentNode.parent != nil) {
      currentNode = currentNode.parent!
    }
    return currentNode
  }
  
  
  func addWord(word: String, lexiconIndex lexI: Int, context: NSManagedObjectContext) {
    // Safely add a word.
    // Got to root, then use moveToChild, which creates child if needed.
    guard !word.isEmpty else { return }
    let lword = word.uppercased()
    
    var node = self
    if self.parent != nil {
      node = self.getRoot()!
    }
    for char in lword {
      node = node.moveToChild(value: String(char), context: context)!
    }
    node.isWord = true
    if node.lexiconList == nil {
      node.lexiconList = Array(repeating: false, count: lexiconOrder.count)
    }
    node.lexiconList![lexI] = true
  }
  
  
  func memoryContainsWord(word: String, lexicon: Int) -> Bool {
    return false
  }
  
  
  func traceString(word: String) -> TrieNode? {
    var currentNode: TrieNode?
    currentNode = self
    for char in word {
      currentNode = currentNode?.getChild(val: String(char)) ?? nil
    }
    
    return currentNode
  }
  
  
  func getChildren() -> Set<TrieNode> {
    let s = Set<TrieNode>()
    return s
  }
  
  
  func getValue() -> String {
    return self.value!
  }
  
  
  func completeTrieFromFile(fName: String, lexiconIndex lexI: Int, context: NSManagedObjectContext) {
    
    if let path = Bundle.main.path(forResource: fName, ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        print(fName, "got data")
        let myStrings = data.components(separatedBy: .newlines)
        print(fName, "got strings")
        for word in myStrings {
          self.addWord(word: word, lexiconIndex: lexI, context: context)
        }
      } catch {
        print("error for", fName)
      }
    }
    
    print("storing")
    do {
      try context.save()
    } catch {
      print("fail")
    }
    print("trie built using insert")
  }
  

}
