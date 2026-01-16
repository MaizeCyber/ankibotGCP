ANKIHELPER_INSTRUCTION = "\nYou create Anki cards based on the user input. The user input will be Chinese characters, Japanese Kanji, Japanese Hiragana, Japanese Katakana, or Spanish\n"

DECKNAME_INSTRUCTION = f"\nYour JSON should NOT include any keys or fields other than the ones shown in the given examples. You should not change the deckName or modelName values shown in the examples. All values which are blank in the examples should be left blank in the JSON. All other fields should be filled given the context of the examples.\n"

EXAMPLES_ROMANTIC = f"""
Examples:

User:
sencillo

You:
{{
    "deckName": spanish,
    "modelName": romantic,
    "tags": ["AI-Generated"],
    "fields": {{
        "Key": "sencillo",
        "Meaning": "simple",
        "Part of speech": "adjective",
        "Gender": "",
        "Plural": "",
        "Conjugation": "",
        "Tense": "",
        "Audio": "",
        "Homophone": "",
        "Homograph": "",
        "Sentence": "El diseño de mi casa es muy sencillo.",
        "SentenceCloze": "El diseño de mi casa es muy [ ].",
        "SentenceMeaning": "The design of my house is very simple.",
        "SentenceAudio": "",
        "SentenceImage": "",
    }}
}}

User:
pelear

You:
{{
    "deckName": spanish,
    "modelName": romantic,
    "tags": ["AI-Generated"],
    "fields": {{
        "Key": "pelear",
        "Meaning": "to fight",
        "Part of speech": "verb",
        "Gender": "",
        "Plural": "",
        "Conjugation": "",
        "Tense": "infinitive",
        "Audio": "",
        "Homophone": "",
        "Homograph": "",
        "Sentence": "Los hermanos comenzaron a pelear por el último pedazo de pizza.",
        "SentenceCloze": "Los hermanos comenzaron a [ ] por el último pedazo de pizza.",
        "SentenceMeaning": "The brothers started fighting over the last slice of pizza.",
        "SentenceAudio": "",
        "SentenceImage": "",
    }}
}}
"""

EXAMPLES_JAPONIC = f"""
Examples:

User:
元気

You:
{{
    "deckName": japanese,
    "modelName": japonic,
    "tags": ["AI-Generated"],
    "fields": {{
        "Key": "元気",
        "Hiragana": "す・き",
        "Meaning": "healthy",
        "Part of speech": "adjective",
        "Audio": "",
        "Homophone": "",
        "Homograph": "",
        "PitchAccent": "",
        "Sentence": "今日も元気ですか？",
        "SentenceCloze": "今日も[ ]ですか？",
        "SentenceHirigana": "きょうもげんきですか？",
        "SentenceFurigana": "私[わたし]は 貧[まず]しい 家庭[かてい]で 育[そだ]ちました。",
        "SentenceMeaning": "Are you feeling good today?",
        "SentenceAudio": "",
        "SentenceImage": "",
    }}
}}

User:
で particle

You:
{{
    "deckName": japanese,
    "modelName": japonic,
    "tags": ["AI-Generated"],
    "fields": {{
        "Key": "で",
        "Hiragana": "で",
        "Meaning": "At place, by way of",
        "Part of speech": "particle",
        "Audio": "",
        "Homophone": "",
        "Homograph": "",
        "PitchAccent": "",
        "Sentence": "私は 貧しい 家庭で育ちました。",
        "SentenceCloze": "私は 貧しい 家庭[ ]育ちました。",
        "SentenceHirigana": "わたしは まずしい かていで そだちました。",
        "SentenceFurigana": "私[わたし]は 貧[まず]しい 家庭[かてい]で 育[そだ]ちました。",
        "SentenceMeaning": "I grew up in a poor family",
        "SentenceAudio": "",
        "SentenceImage": "",

    }}

}}
"""

EXAMPLES_HSK = f"""
Examples:

User:
便宜

You:
{{
    "deckName": chinese,
    "modelName": HSK,
    "tags": ["AI-Generated"],
    "fields": {{
        "Key": "便宜",
        "Simplified": "便宜",
        "Traditional": "便宜",
        "Pinyin.1": "piányi",
        "Pinyin.2": "pian2yi5",
        "Meaning": "cheap",
        "Part of speech": "adjective",
        "Audio": "",
        "Homophone": "",
        "Homograph": "",
        "SentenceSimplified": "这件衣服很便宜。",
        "SentenceTraditional": "這件衣服很便宜。",
        "SentenceSimplifiedCloze": "这件衣服很[ ]。",
        "SentenceTraditionalCloze": "這件衣服很[ ]。",
        "SentencePinyin.1": "Zhè jiàn yīfu hěn piányi.",
        "SentencePinyin.2": "Zhe4 jian4 yi1fu hen3 pian2yi.",
        "SentenceMeaning": "These clothes are very cheap.",
        "SentenceAudio": "",
        "SentenceImage": "",
    }}
}}

User:
本垒打

You:
{{
    "deckName": chinese,
    "modelName": HSK,
    "tags": ["AI-Generated"],
    "fields": {{
        "Key": "本垒打",
        "Simplified": "本垒打",
        "Traditional": "全壘打",
        "Pinyin.1": "běnlěidǎ",
        "Pinyin.2": "ben3lei3da3",
        "Meaning": "home run",
        "Part of speech": "noun",
        "Audio": "",
        "Homophone": "",
        "Homograph": "",
        "SentenceSimplified": "他在比赛中打出一个本垒打，帮助球队获胜。",
        "SentenceTraditional": "他在比賽中打出一個全壘打，幫助球隊獲勝。",
        "SentenceSimplifiedCloze": "他在比赛中打出一个[ ]，帮助球队获胜。",
        "SentenceTraditionalCloze": "他在比賽中打出一個[ ]，幫助球隊獲勝。",
        "SentencePinyin.1": "Tā zài bǐsài zhōng dǎchū yí gè běnlěidǎ, bāngzhù qiúduì huòshèng.",
        "SentencePinyin.2": "Ta1 zai4 bi3sai4 zhong1 da3chu1 yi2 ge4 ben3lei3da3, bang1zhu4 qiu2dui4 huo4sheng1.",
        "SentenceMeaning": "He hit a home run in the game, helping his team win.",
        "SentenceAudio": "",
        "SentenceImage": "",
    }}
}}
"""


ROMANTIC_SCHEMA = {
    "type": "object",
    "properties": {
        "deckName": {"type": "string", "default": "spanish"},
        "modelName": {"type": "string", "default": "romantic"},
        "tags": {
            "type": "array",
            "items": {"type": "string", "default": "AI-Generated"}
        },
        "fields": {
            "type": "object",
            "properties": {
                "Key": {"type": "string", "description": "The Spanish word being translated"},
                "Meaning": {"type": "string", "description": "Primary English translation"},
                "Part of speech": {"type": "string", "description": "e.g., noun, verb, adjective"},
                "Gender": {"type": "string", "description": "For nouns: masculine or feminine. Empty otherwise."},
                "Plural": {"type": "string", "description": "Plural form if irregular. Empty otherwise."},
                "Conjugation": {"type": "string", "description": "Verb conjugation notes if applicable."},
                "Tense": {"type": "string", "description": "Verb tense if applicable."},
                "Audio": {"type": "string", "default": ""},
                "Homophone": {"type": "string", "default": ""},
                "Homograph": {"type": "string", "default": ""},
                "Sentence": {"type": "string", "description": "A natural example sentence in Spanish."},
                "SentenceCloze": {"type": "string", "description": "The sentence with the word replaced by [ ]."},
                "SentenceMeaning": {"type": "string", "description": "English translation of the sentence."},
                "SentenceAudio": {"type": "string", "default": ""},
                "SentenceImage": {"type": "string", "default": ""}
            },
            "required": ["Key", "Meaning", "Part of speech", "Sentence", "SentenceCloze"]
        }
    },
    "required": ["deckName", "modelName", "tags", "fields"]
}

JAPONIC_SCHEMA = {
    "type": "object",
    "properties": {
        "deckName": {"type": "string", "default": "japanese"},
        "modelName": {"type": "string", "default": "japonic"},
        "tags": {
            "type": "array",
            "items": {"type": "string", "default": "AI-Generated"}
        },
        "fields": {
            "type": "object",
            "properties": {
                "Key": {"type": "string", "description": "The Japanese word (Kanji or Kana)"},
                "Hiragana": {"type": "string", "description": "The reading in Hiragana only"},
                "Meaning": {"type": "string"},
                "Part of speech": {"type": "string"},
                "Audio": {"type": "string", "default": ""},
                "Homophone": {"type": "string", "default": ""},
                "Homograph": {"type": "string", "default": ""},
                "PitchAccent": {"type": "string", "description": "Pitch accent pattern (e.g., Heiban, Atamadaka)"},
                "Sentence": {"type": "string", "description": "Natural Japanese sentence (Kanji + Kana)"},
                "SentenceCloze": {"type": "string", "description": "Sentence with the Key replaced by [ ]"},
                "SentenceHiragana": {"type": "string", "description": "The entire sentence in Hiragana"},
                "SentenceFurigana": {"type": "string", "description": "Sentence with furigana in format: 漢字[かんじ]"},
                "SentenceMeaning": {"type": "string"},
                "SentenceAudio": {"type": "string", "default": ""},
                "SentenceImage": {"type": "string", "default": ""}
            },
            "required": ["Key", "Hiragana", "Meaning", "Sentence", "SentenceFurigana"]
        }
    },
    "required": ["deckName", "modelName", "tags", "fields"]
}

HSK_SCHEMA = {
    "type": "object",
    "properties": {
        "deckName": {"type": "string", "default": "chinese"},
        "modelName": {"type": "string", "default": "HSK"},
        "tags": {
            "type": "array",
            "items": {"type": "string", "default": "AI-Generated"}
        },
        "fields": {
            "type": "object",
            "properties": {
                "Key": {"type": "string", "description": "关键词（通常为简体）"},
                "Simplified": {"type": "string", "description": "简体中文字符"},
                "Traditional": {"type": "string", "description": "繁体中文字符"},
                "Pinyin.1": {"type": "string", "description": "带声调符号的拼音，例如: piányi"},
                "Pinyin.2": {"type": "string", "description": "带数字声调的拼音，例如: pian2yi5"},
                "Meaning": {"type": "string"},
                "Part of speech": {"type": "string"},
                "Audio": {"type": "string", "default": ""},
                "Homophone": {"type": "string", "default": ""},
                "Homograph": {"type": "string", "default": ""},
                "SentenceSimplified": {"type": "string", "description": "简体中文例句"},
                "SentenceTraditional": {"type": "string", "description": "繁体中文例句"},
                "SentenceSimplifiedCloze": {"type": "string", "description": "简体中文完形填空例句"},
                "SentenceTraditionalCloze": {"type": "string", "description": "繁体中文完形填空例句"},
                "SentencePinyin.1": {"type": "string", "description": "例句的带声调符号拼音"},
                "SentencePinyin.2": {"type": "string", "description": "例句的数字声调拼音"},
                "SentenceMeaning": {"type": "string", "description": "例句的英文翻译"},
                "SentenceAudio": {"type": "string", "default": ""},
                "SentenceImage": {"type": "string", "default": ""}
            },
            "required": ["Key", "Simplified", "Traditional", "Pinyin.1", "Meaning", "SentenceSimplified"]
        }
    },
    "required": ["deckName", "modelName", "tags", "fields"]
}
