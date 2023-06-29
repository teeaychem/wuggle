//
//  FoundWordView.swift
//  woggle
//
//  Created by sparkes on 2023/06/26.
//

import UIKit

class FoundWordView: UITableView {
  
  var wordList =  [GameWord]()
  
  private let listDimensions: CGSize
  private let fontSize: CGFloat
  
  init(listDimensions lD: CGSize) {
    
    listDimensions = lD
    fontSize = lD.height * 0.15
    
    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: listDimensions), style: .plain)
    
    separatorStyle = .none
    dataSource = self
    delegate = self
    rowHeight = UIFont(name: textFontName, size: fontSize)!.lineHeight
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension FoundWordView: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wordList.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Getting the right element
    let word = wordList[indexPath.row]
    
    // Trying to reuse a cell
    let cellIdentifier = word.value!
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    ?? UITableViewWordCell(style: .default, reuseIdentifier: cellIdentifier, word: word, width: listDimensions.width, height: rowHeight, shadeWords: false)
    return cell
  }
  
  
  // This fades a row if it's been selected. Should figure out how to disable this.
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//  }
  
  // Later, I should add some kind of gradient, and this is one way to do it.
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }
  
  private func gameWordHasValue(word w: GameWord, value v: String) -> Bool {
    if w.value == v {
      return true
    }
    return false
  }
  
  
  public func updateAndScroll(word: GameWord) {
    var wordIndex: Int
    
    let first = wordList.first(where: { $0.value == word.value})
    
    if (first != nil) {
      wordIndex = wordList.firstIndex(of: first!)!
    } else {
      wordIndex = wordList.count
      wordList.append(word)
      reloadData()
    }
      scrollToRow(at: [0, wordIndex], at: .middle, animated: true)
  }
  
  public func listUpdateAndScroll(updateList: [GameWord]) {
    for word in updateList { wordList.append(word) }
    reloadData()
    if (wordList.count > 0) { scrollToRow(at: [0, wordList.count - 1], at: .bottom, animated: false) } // Count is total, etc.
  }
  
  
  public func clearWords() {
    wordList.removeAll()
    reloadData()
  }
}
