// TO DO: check https://pub.dev/packages/intl
bool isConsonant(String text) {
  final List<String> consonants = [
    'b',
    'c',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'm',
    'n',
    'p',
    'q',
    'r',
    's',
    't',
    'v',
    'w',
    'x',
    'z',
  ];
  return 0 <= consonants.indexOf(text.toLowerCase());
}

bool isVowel(String text) {
  final List<String> vowels = ['a', 'e', 'i', 'o', 'u', 'y'];
  return 0 <= vowels.indexOf(text.toLowerCase());
}

bool isLower(String text) => text.toLowerCase() == text;

bool isUpper(String text) => text.toUpperCase() == text;

String dropFirst(String text, {int count = 1}) =>
    text == null || text.length < count ? text : text.substring(count);

String dropLast(String text, {int count = 1}) =>
    text == null || text.length < count
        ? text
        : text.substring(0, text.length - count);

String first(String text, {int count = 1}) =>
    text == null || text.length < count ? text : text.substring(0, count);

String last(String text, {int count = 1}) => text == null || text.length < count
    ? text
    : text.substring(text.length - count);

String plural(String noun) {
  if (noun == null || noun.length < 2) return noun;
  final String lower = noun.toLowerCase();
  String suffix;
  // https://www.grammarly.com/blog/plural-nouns/
  // irregular words
  final Map<String, String> irregularWords = {
    'child': 'children',
    'foot': 'feet',
    'goose': 'geese',
    'man': 'men',
    'mouse': 'mice',
    'person': 'people',
    'tooth': 'teeth',
    'woman': 'women',
  };
  final String pluralNoun = irregularWords[lower];
  if (pluralNoun != null) {
    noun = first(noun);
    suffix = dropFirst(pluralNoun);
  }
  // exceptions to rules 4 and 7
  else if (lower == 'belief' ||
      lower == 'chef' ||
      lower == 'chief' ||
      lower == 'halo' ||
      lower == 'photo' ||
      lower == 'piano' ||
      lower == 'roof')
    suffix = 's';
  // rule 11: some nouns don't change
  else if (lower == 'fish' ||
      lower == 'deer' ||
      lower == 'series' ||
      lower == 'sheep' ||
      lower == 'species')
    suffix = '';
  // rule 10: ends in -on: replace with -a
  else if (lower.endsWith('on')) {
    noun = dropLast(noun, count: 2);
    suffix = 'a';
  }
  // rule 9: ends in -is: replace with -es
  else if (lower.endsWith('is')) {
    noun = dropLast(noun, count: 2);
    suffix = 'es';
  }
  // rule 8: ends in ‑us: frequently replace with ‑i
  else if (4 < lower.length && lower.endsWith('us')) {
    noun = dropLast(noun, count: 2);
    suffix = 'i';
  }
  // rule 7: ends with -o, add -es
  else if (lower.endsWith('o'))
    suffix = 'es';
  // rules 5-6: ends in ‑y and ...
  else if (lower.endsWith('y')) {
    final String beforeLast = first(last(lower, count: 2));
    if (isVowel(beforeLast))
      // rule 6: ...has vowel before: add -s
      suffix = 's';
    else {
      // rule 5: ...has consonant before: replace with -es
      noun = dropLast(noun);
      suffix = 'ies';
    }
  }
  // rule 4: ends with ‑f or ‑fe, the f changed to ‑ve before adding the -s
  else if (lower.endsWith('f')) {
    noun = dropLast(noun);
    suffix = 'ves';
  } else if (lower.endsWith('fe')) {
    noun = dropLast(noun, count: 2);
    suffix = 'ves';
  }
  // rule 3: some -s or -z: double the -s or -z prior to adding the -es
  else if (lower == 'fez' || lower == 'gas')
    suffix = '${last(noun)}es';
  // rule 2: ends in ‑s, -ss, -sh, -ch, -x, or -z: add ‑es
  else if (lower.endsWith('ch') ||
      lower.endsWith('s') ||
      lower.endsWith('sh') ||
      lower.endsWith('x') ||
      lower.endsWith('z'))
    suffix = 'es';
  // rule 1: add ‑s
  else
    suffix = 's';
  // if last character is uppercase, convert the suffix to uppercase
  if (isUpper(last(noun))) suffix = suffix.toUpperCase();
  return '$noun$suffix';
}

String pluralize(int number, String noun) {
  return '$number ${number.abs() == 1 ? noun : plural(noun)}';
}

void test() {
  int errors = 0;
  int oks = 0;
  final Map<String, String> words = {
    'analysis': 'analyses',
    'belief': 'beliefs',
    'blitz': 'blitzes',
    'boy': 'boys',
    'bus': 'buses',
    'cactus': 'cacti',
    'cat': 'cats',
    'chef': 'chefs',
    'chief': 'chiefs',
    'child': 'children',
    'city': 'cities',
    'criterion': 'criteria',
    'deer': 'deer',
    'ellipsis': 'ellipses',
    'fez': 'fezzes',
    'fish': 'fish',
    'focus': 'foci',
    'foot': 'feet',
    'gas': 'gasses',
    'goose': 'geese',
    'halo': 'halos',
    'house': 'houses',
    'lunch': 'lunches',
    'man': 'men',
    'marsh': 'marshes',
    'mouse': 'mice',
    'person': 'people',
    'phenomenon': 'phenomena',
    'photo': 'photos',
    'piano': 'pianos',
    'potato': 'potatoes',
    'puppy': 'puppies',
    'ray': 'rays',
    'roof': 'roofs',
    'series': 'series',
    'sheep': 'sheep',
    'species': 'species',
    'tax': 'taxes',
    'tomato': 'tomatoes',
    'tooth': 'teeth',
    'truss': 'trusses',
    'volcano': 'volcanoes',
    'wife': 'wives',
    'wolf': 'wolves',
    'woman': 'women',
  };
  for (String word in words.keys) {
    final String pluralWord = plural(word);
    final String checkedPluralWord = words[word];
    final bool ok = pluralWord == checkedPluralWord;
    if (ok)
      oks++;
    else
      errors++;
    print(
        '$word — $pluralWord ${ok ? 'OK' : 'ERROR, should be $checkedPluralWord'}');
  }
  print('$oks OK${errors == 0 ? '' : ', $errors ERRORS'}');
}

// main() => test();
