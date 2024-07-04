//
//  String+Extensions.swift
//  InstPost
//
//  Created by Amit singh on 04/07/24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
          return prefix(1).uppercased() + dropFirst()
      }
      
      mutating func capitalizeFirstLetter() {
          self = self.capitalizingFirstLetter()
      }
}
