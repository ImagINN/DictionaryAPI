//
//  MockWordJSON.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation

// MARK: - Array: "ba" (3 eleman)
let mockFirstWordJSON: Data = """
[
  {
    "word": "ba",
    "phonetics": [],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          {
            "definition": "(Egyptian mythology) A being's soul or personality, represented as a bird-headed figure, which survives after death but must be sustained with offerings of food.",
            "synonyms": [],
            "antonyms": []
          }
        ],
        "synonyms": [],
        "antonyms": []
      }
    ]
  },
  {
    "word": "ba",
    "phonetics": [],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          { "definition": "Father, baba.", "synonyms": [], "antonyms": [] }
        ],
        "synonyms": [],
        "antonyms": []
      }
    ]
  },
  {
    "word": "ba",
    "phonetics": [],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          { "definition": "A medieval football game played in parts of Scotland around Christmas and New Year.", "synonyms": [], "antonyms": [] }
        ],
        "synonyms": [],
        "antonyms": []
      }
    ]
  }
]
""".data(using: .utf8)!

// MARK: - Array: "home" (1 eleman)
let mockSecondWordJSON: Data = """
[
  {
    "word": "home",
    "phonetic": "/(h)əʊm/",
    "phonetics": [
      { "text": "/(h)əʊm/", "audio": "" },
      {
        "text": "/hoʊm/",
        "audio": "https://api.dictionaryapi.dev/media/pronunciations/en/home-us.mp3",
        "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=711130"
      }
    ],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          { "definition": "A dwelling.", "synonyms": [], "antonyms": [] },
          { "definition": "One’s native land; the place or country in which one dwells; the place where one’s ancestors dwell or dwelt.", "synonyms": [], "antonyms": [] },
          { "definition": "The locality where a thing is usually found, or was first found, or where it is naturally abundant; habitat; seat.", "synonyms": [], "antonyms": [], "example": "the home of the pine" },
          { "definition": "A focus point.", "synonyms": [], "antonyms": [] }
        ],
        "synonyms": ["home base","abode","domicile","dwelling","house","residence","tenement"],
        "antonyms": []
      },
      {
        "partOfSpeech": "verb",
        "definitions": [
          { "definition": "(of animals) To return to its owner.", "synonyms": [], "antonyms": [], "example": "The dog homed." },
          { "definition": "(always with \\"in on\\") To seek or aim for something.", "synonyms": [], "antonyms": [], "example": "The missile was able to home in on the target." }
        ],
        "synonyms": [],
        "antonyms": []
      },
      {
        "partOfSpeech": "adjective",
        "definitions": [
          { "definition": "Of or pertaining to one’s dwelling or country; domestic; not foreign; as home manufactures; home comforts.", "synonyms": [], "antonyms": [] },
          { "definition": "(except in phrases) That strikes home; direct, pointed.", "synonyms": [], "antonyms": [] },
          { "definition": "Personal, intimate.", "synonyms": [], "antonyms": [] },
          { "definition": "Relating to the home team (the team at whose venue a game is played).", "synonyms": [], "antonyms": ["away","road","visitor"], "example": "the home end, home advantage, home supporters" }
        ],
        "synonyms": [],
        "antonyms": ["away","road","visitor"]
      },
      {
        "partOfSpeech": "adverb",
        "definitions": [
          { "definition": "To one's home", "synonyms": [], "antonyms": [] },
          { "definition": "At or in one's place of residence or one's customary or official location; at home", "synonyms": [], "antonyms": [], "example": "Everyone's gone to watch the game; there's nobody home." },
          { "definition": "To a full and intimate degree; to the heart of the matter; fully, directly.", "synonyms": [], "antonyms": [] },
          { "definition": "Into the goal", "synonyms": [], "antonyms": [] },
          { "definition": "Into the right, proper or stowed position", "synonyms": [], "antonyms": [], "example": "sails sheeted home" }
        ],
        "synonyms": ["homeward"],
        "antonyms": []
      },
      {
        "partOfSpeech": "noun",
        "definitions": [
          { "definition": "A directory that contains a user's files.", "synonyms": [], "antonyms": [] }
        ],
        "synonyms": [],
        "antonyms": []
      }
    ]
  }
]
""".data(using: .utf8)!
