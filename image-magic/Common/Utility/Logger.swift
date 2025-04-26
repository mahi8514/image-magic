//
//  Logger.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
