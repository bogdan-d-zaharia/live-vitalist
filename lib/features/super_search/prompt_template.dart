const String promptTemplate = r'''
Salut!

Scopul tău e să formezi câte un JSON cu date nutriționale din informația furnizată.

Spre exemplu, dacă se furnizează textul "Croissant", să încerci să pui pe un JSON date nutriționale reprezentative unui croissant.

Dacă se furnizează o etichetă, să copii numele și valorile de pe etichetă.

Încearcă să incluzi cât mai multe date, asta înseamnă în general micronutrienti precum vitamine, minerale. Spre exemplu, dacă se trimite o poză cu o pungă de semințe de floarea soarelui și declarația nutrițională, mai întâi copii numele de pe pungă, nutientii specifici care se mentioneaza pe pungă iar apoi să adaugi, să îmbogățești informațiile cu un profil de vitamine, minerale tipici semințelor de floarea soarelui, precum o cantitate mare de magneziu. Din nou, ce e scris e baza, ce e tipic e extra. Dacă pe etichetă scrie 300 calorii și pe internet 200 pui 300 ca pe etichetă. E intuitiv.

Acesta este modelul de JSON peste care să construiești. Vreau să îți zic că dacă schimbi numele cheilor nu va mai funcționa. De asemenea se spune și unitatea în care este măsurat fiecare nutrient. Și îți mai zic doar de reference size și unit. Practic când vezi "valori pe 100g produs" înseamnă că avem un reference size de 100 și unitatea "g", grame. Dacă aveam valori pentru o unitate spre exemplu am fi pus 1 "unit", din nou, intuitiv.

{
  "name": "",
  "unit": "g",
  "referenceSize": 100.0,
  "referenceFields": {
    "kcals": null, // kcal
    "protein": null, // g
    "fats": null, // g
    "satFats": null, // g
    "carbs": null, // g
    "sugars": null, // g
    "fibers": null, // g
    "cholesterol": null, // mg
    "omega3": null, // g
    "omega6": null, // g
    "vitaminA": null, // mcg
    "vitaminB1": null, // mg
    "vitaminB2": null, // mg
    "vitaminB3": null, // mg
    "vitaminB4": null, // mg
    "vitaminB5": null, // mg
    "vitaminB6": null, // mg
    "vitaminB7": null, // mcg
    "vitaminB9": null, // mcg
    "vitaminB12": null, // mcg
    "vitaminC": null, // mg
    "vitaminD3": null, // mcg
    "vitaminE": null, // mg
    "vitaminK1": null, // mcg
    "vitaminK2": null, // mcg
    "calcium": null, // mg
    "sodium": null, // mg
    "potassium": null, // mg
    "iron": null, // mg
    "zinc": null, // mg
    "magnesium": null, // mg
  },
  "unitSynonyms": {
  } // eg. "portion": 60, meaning 60 units, like 60 grams
}

Input:

<<input-ul>>
''';
