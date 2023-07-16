//
//  FoundWordView.swift
//  wuggle
//
//  Created by sparkes on 2023/06/26.
//

import UIKit

class FoundWordView: UITableView {
  
  let uiData: UIData
  private var wordList = [(String, Bool)]()
  private let listDimensions: CGSize
  
  init(uiData uiD: UIData, listDimensions lD: CGSize, rowHieght rH: CGFloat) {
    
    uiData = uiD
    listDimensions = lD
    
    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: listDimensions), style: .plain)
    
    separatorStyle = .none
    dataSource = self
    delegate = self
    rowHeight = rH
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension FoundWordView: UITableViewDataSource, UITableViewDelegate {
  
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wordList.count
  }
  
  
  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Getting the right element
    let word = wordList[indexPath.row]
    
    // Trying to reuse a cell
    let cellIdentifier = word.0
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    ?? UITableViewWordCell(uiData: uiData, cellStyle: .default, word: word.0, found: word.1, size: CGSize(width: listDimensions.width, height: rowHeight))
    // To disable highlighting cell when tapped.
    cell.selectionStyle = .none
    return cell
  }
  
  // Later, I should add some kind of gradient, and this is one way to do it.
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }
  

  public func updateNoScroll(word: String, found: Bool) {
    wordList.append((word, found))
    reloadData()
  }
  
  
  public func maybeOverWrite(word: String, found: Bool) {
    // Check to see if word is in list.
    // If so, overwrite with found arg.
    // Else, add as usual.
    if (wordList.first(where: { $0.0 == word}) != nil) {
      wordList[wordList.firstIndex(where: { $0.0 == word})!] = (word, found)
    } else {
      wordList.append((word, found))
    }
  }
  
  
  public func updateAndScroll(word: String, found: Bool) {
    var wordIndex: Int
    
    if (wordList.first(where: { $0.0 == word}) != nil) {
      wordIndex = wordList.firstIndex(where: { $0.0 == word})!
    } else {
      wordIndex = wordList.count
      wordList.append((word, found))
      reloadData()
    }
      scrollToRow(at: [0, wordIndex], at: .middle, animated: true)
    // TODO: Add some visial flair, at the moment it's not clear what this is doing.
  }
  
  public func listUpdateAndScroll(updateList: [(String, Bool)]) {
    for word in updateList { wordList.append(word) }
    reloadData()
    if (wordList.count > 0) { scrollToRow(at: [0, wordList.count - 1], at: .bottom, animated: false) } // Count is total, etc.
  }
  
  
  public func clearWords() {
    wordList.removeAll()
    reloadData()
  }
}
