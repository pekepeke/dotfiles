// hiragana only
"/^(\xe3(\x81[\x81-\xbf]|\x82[\x80-\x93]|\x83\xbc))*$/"
// katakana only
"/^(\xe3(\x82[\xa1-\xbf]|\x83[\x80-\xb6]|\x83\xbc|\x82\x9b|\x82\x9c))*$/"
// zenkaku only
"/(?:\xEF\xBD[\xA1-\xBF]|\xEF\xBE[\x80-\x9F])|[\x20-\x7E]/"
// tel/fax
'/^(0\d{1,4}[\s-]?\d{1,4}[\s-]?\d{1,4}|\+\d{1,3}[\s-]?\d{1,4}[\s-]?\d{1,4}[\s-]?\d{1,4})$/'
// mobile email jp
'/^[a-z0-9\._-]{3,30}@(?:[a-z0-9][-a-z0-9]*\.)*(?:[a-z0-9][-a-z0-9]{0,62})\.(?:(?:[a-z]{2}\.)?[a-z]{2,4})$/i'

