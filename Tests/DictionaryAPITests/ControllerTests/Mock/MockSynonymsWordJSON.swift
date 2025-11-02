//
//  MockSynonymsWordJSON.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation

// MARK: - Array: "ba" (5 eleman)

let mockFirstSynonymsWordJSON: Data = """
[
  {
    "word": "ab",
    "score": 4064
  },
  {
    "word": "barium",
    "score": 53
  },
  {
    "word": "artium baccalaurens",
    "score": 9
  },
  {
    "word": "atomic number 56",
    "score": 9
  },
  {
    "word": "bachelor of arts"
  }
]
""".data(using: .utf8)!

// MARK: - Array: "home" (19 eleman)

let mockSecondSynonymsWordJSON: Data = """
[
  {
    "word": "base",
    "score": 58114
  },
  {
    "word": "abode",
    "score": 21041
  },
  {
    "word": "domicile",
    "score": 18054
  },
  {
    "word": "menage",
    "score": 16022
  },
  {
    "word": "dwelling",
    "score": 13040
  },
  {
    "word": "house",
    "score": 12073
  },
  {
    "word": "family",
    "score": 8086
  },
  {
    "word": "plate",
    "score": 7067
  },
  {
    "word": "internal",
    "score": 7041
  },
  {
    "word": "habitation",
    "score": 3036
  },
  {
    "word": "nursing home",
    "score": 1034
  },
  {
    "word": "rest home",
    "score": 1026
  },
  {
    "word": "home plate",
    "score": 28
  },
  {
    "word": "dwelling house",
    "score": 19
  },
  {
    "word": "central"
  },
  {
    "word": "household"
  },
  {
    "word": "interior"
  },
  {
    "word": "national"
  },
  {
    "word": "place"
  }
]
""".data(using: .utf8)!
