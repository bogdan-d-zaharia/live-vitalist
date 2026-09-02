import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class FoodImagePicker extends StatelessWidget {
  const FoodImagePicker({
    required this.selectedKey,
    required this.onChanged,
    super.key,
  });

  final String? selectedKey;
  final ValueChanged<String> onChanged;

  Future<void> _openPicker(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FoodImagePickerSheet(selectedKey: selectedKey),
    );

    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final selected = foodImageForKey(selectedKey);
    final selectedName =
        selected == null ? null : l.alimentImageName(selected.key);

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Tooltip(
          message: selected == null
              ? l.alimentImagePickerChooseTooltip
              : l.alimentImagePickerChangeTooltip(selectedName!),
          child: Semantics(
            button: true,
            label: selected == null
                ? l.alimentImagePickerChooseTooltip
                : l.alimentImagePickerChangeTooltip(selectedName!),
            child: Material(
              color: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: colors.outlineVariant),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _openPicker(context),
                child: _FoodImageSquare(
                  image: selected,
                  size: 156.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FoodImageThumbnail extends StatelessWidget {
  const FoodImageThumbnail({
    required this.imageKey,
    required this.fallbackName,
    this.size = 54.0,
    super.key,
  });

  final String? imageKey;
  final String fallbackName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final image =
        foodImageForKey(imageKey) ?? suggestFoodImageForName(fallbackName);

    return SizedBox.square(
      dimension: size,
      child: Center(
        child: Text(
          image?.emoji ?? '🍽️',
          style: TextStyle(fontSize: size * 0.58),
        ),
      ),
    );
  }
}

class _FoodImagePickerSheet extends StatefulWidget {
  const _FoodImagePickerSheet({required this.selectedKey});

  final String? selectedKey;

  @override
  State<_FoodImagePickerSheet> createState() => _FoodImagePickerSheetState();
}

class _FoodImagePickerSheetState extends State<_FoodImagePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodImageOption> _filteredImages(AppLocalizations l) {
    final query = _normalize(_query);
    if (query.isEmpty) return foodImageCatalog;

    return foodImageCatalog.where((image) {
      final searchable = _normalize(
        '${l.alimentImageName(image.key)} ${image.name} ${image.searchTerms}',
      );
      return searchable.contains(query);
    }).toList();
  }

  String _normalize(String value) =>
      removeDiacritics(value.toLowerCase().trim());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l = AppLocalizations.of(context);
    final images = _filteredImages(l);

    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Material(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              width: 42.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(99.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 14.0, 12.0, 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.alimentImagePickerChooseTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          l.alimentImagePickerImageCount(images.length),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l.alimentImagePickerCloseTooltip,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
              child: SearchBar(
                controller: _searchController,
                autoFocus: false,
                hintText: l.alimentImagePickerSearchHint,
                leading: const Icon(Icons.search_rounded),
                trailing: [
                  if (_query.isNotEmpty)
                    IconButton(
                      tooltip: l.alimentImagePickerClearSearchTooltip,
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                ],
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: images.isEmpty
                  ? _EmptyImageSearch(query: _query)
                  : GridView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 24.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final image = images[index];
                        final isSelected = image.key == widget.selectedKey;
                        return _FoodImageTile(
                          image: image,
                          displayName: l.alimentImageName(image.key),
                          selected: isSelected,
                          onTap: () => Navigator.pop(context, image.key),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodImageTile extends StatelessWidget {
  const _FoodImageTile({
    required this.image,
    required this.displayName,
    required this.selected,
    required this.onTap,
  });

  final FoodImageOption image;
  final String displayName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
          width: selected ? 2.0 : 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(image.emoji, style: const TextStyle(fontSize: 38.0)),
                    const SizedBox(height: 4.0),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: 7.0,
                right: 7.0,
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 14.0,
                    color: colors.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FoodImageSquare extends StatelessWidget {
  const _FoodImageSquare({
    required this.image,
    required this.size,
  });

  final FoodImageOption? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          image?.emoji ?? '🍽️',
          style: TextStyle(fontSize: size * 0.46),
        ),
      ),
    );
  }
}

class _EmptyImageSearch extends StatelessWidget {
  const _EmptyImageSearch({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_search_rounded,
              size: 52.0,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 14.0),
            Text(
              AppLocalizations.of(context).alimentImagePickerEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              AppLocalizations.of(context)
                  .alimentImagePickerEmptyMessage(query),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodImageOption {
  const FoodImageOption(this.key, this.name, this.emoji, this.searchTerms);

  final String key;
  final String name;
  final String emoji;
  final String searchTerms;
}

FoodImageOption? foodImageForKey(String? key) {
  if (key == null) return null;
  for (final image in foodImageCatalog) {
    if (image.key == key) return image;
  }
  return null;
}

FoodImageOption? suggestFoodImageForName(String value) {
  final query = _normalizeFoodText(value);
  if (query.length < 2) return null;

  final queryTokens = query.split(' ').where((token) => token.isNotEmpty);
  FoodImageOption? bestMatch;
  double bestScore = 0.0;

  for (final image in foodImageCatalog) {
    final name = _normalizeFoodText(image.name);
    final key = _normalizeFoodText(image.key.replaceAll('_', ' '));
    final searchTerms = _normalizeFoodText(image.searchTerms);
    final candidates = <String>{
      ...name.split(' '),
      ...key.split(' '),
      ...searchTerms.split(' '),
    }..removeWhere((term) => term.isEmpty);

    var score = 0.0;
    if (query == name || query == key || candidates.contains(query)) {
      score = 100.0;
    } else if (query.length >= 3 && '$name $key $searchTerms'.contains(query)) {
      score = 94.0;
    } else if (name.length >= 3 && query.contains(name)) {
      score = 92.0;
    }

    for (final queryToken in queryTokens) {
      if (queryToken.length < 2) continue;
      for (final candidate in candidates) {
        if (candidate.length < 2) continue;

        if (queryToken == candidate) {
          score = score < 90.0 ? 90.0 : score;
          continue;
        }

        if (queryToken.length >= 3 &&
            (candidate.startsWith(queryToken) ||
                queryToken.startsWith(candidate))) {
          score = score < 84.0 ? 84.0 : score;
          continue;
        }

        if (queryToken.length >= 4 && candidate.length >= 4) {
          final longest = queryToken.length > candidate.length
              ? queryToken.length
              : candidate.length;
          final similarity =
              1.0 - (_levenshteinDistance(queryToken, candidate) / longest);
          final fuzzyScore = similarity * 90.0;
          if (fuzzyScore > score) score = fuzzyScore;
        }
      }
    }

    if (score > bestScore) {
      bestScore = score;
      bestMatch = image;
    }
  }

  return bestScore >= 74.0 ? bestMatch : null;
}

String _normalizeFoodText(String value) {
  return removeDiacritics(value.toLowerCase())
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim();
}

int _levenshteinDistance(String left, String right) {
  if (left == right) return 0;
  if (left.isEmpty) return right.length;
  if (right.isEmpty) return left.length;

  var previous = List<int>.generate(right.length + 1, (index) => index);
  for (var leftIndex = 0; leftIndex < left.length; leftIndex++) {
    final current = <int>[leftIndex + 1];
    for (var rightIndex = 0; rightIndex < right.length; rightIndex++) {
      final insertion = current[rightIndex] + 1;
      final deletion = previous[rightIndex + 1] + 1;
      final substitution = previous[rightIndex] +
          (left.codeUnitAt(leftIndex) == right.codeUnitAt(rightIndex) ? 0 : 1);
      current.add(
        insertion < deletion
            ? (insertion < substitution ? insertion : substitution)
            : (deletion < substitution ? deletion : substitution),
      );
    }
    previous = current;
  }
  return previous.last;
}

const foodImageCatalog = <FoodImageOption>[
  FoodImageOption('apple', 'Apple', '🍎', 'mar fruct red green'),
  FoodImageOption('banana', 'Banana', '🍌', 'banana fruct yellow'),
  FoodImageOption('orange', 'Orange', '🍊', 'portocala citrus fruct'),
  FoodImageOption('lemon', 'Lemon', '🍋', 'lamaie citrus fruct'),
  FoodImageOption('strawberry', 'Strawberry', '🍓', 'capsuna berries fruct'),
  FoodImageOption('grapes', 'Grapes', '🍇', 'struguri fruit fruct'),
  FoodImageOption('watermelon', 'Watermelon', '🍉', 'pepene fruit fruct'),
  FoodImageOption('peach', 'Peach', '🍑', 'piersica fruit fruct'),
  FoodImageOption('cherries', 'Cherries', '🍒', 'cirese fruit fruct'),
  FoodImageOption('pineapple', 'Pineapple', '🍍', 'ananas fruit fruct'),
  FoodImageOption('pear', 'Pear', '🍐', 'para fruit fruct'),
  FoodImageOption('kiwi', 'Kiwi', '🥝', 'kiwi fruit fruct green'),
  FoodImageOption('blueberries', 'Blueberries', '🫐',
      'afine berries fruit fruct antioxidant'),
  FoodImageOption('mango', 'Mango', '🥭', 'mango tropical fruit fruct'),
  FoodImageOption('coconut', 'Coconut', '🥥', 'cocos tropical fruit fruct'),
  FoodImageOption('avocado', 'Avocado', '🥑', 'avocado vegetable healthy'),
  FoodImageOption('tomato', 'Tomato', '🍅', 'rosie tomato vegetable leguma'),
  FoodImageOption('carrot', 'Carrot', '🥕', 'morcov vegetable leguma'),
  FoodImageOption('broccoli', 'Broccoli', '🥦', 'broccoli vegetable leguma'),
  FoodImageOption('corn', 'Corn', '🌽', 'porumb vegetable leguma'),
  FoodImageOption('mushroom', 'Mushroom', '🍄', 'ciuperca vegetable leguma'),
  FoodImageOption('potato', 'Potato', '🥔', 'cartof vegetable leguma'),
  FoodImageOption(
      'cucumber', 'Cucumber', '🥒', 'castravete vegetable leguma green'),
  FoodImageOption(
      'pepper', 'Pepper', '🫑', 'ardei capia bell pepper vegetable leguma'),
  FoodImageOption('onion', 'Onion', '🧅', 'ceapa vegetable leguma'),
  FoodImageOption('garlic', 'Garlic', '🧄', 'usturoi vegetable leguma'),
  FoodImageOption('peas', 'Peas', '🫛', 'mazare vegetable leguma protein'),
  FoodImageOption('leafy_greens', 'Leafy greens', '🥬',
      'verdeturi salata varza lettuce vegetable leguma'),
  FoodImageOption('olives', 'Olives', '🫒', 'masline healthy fats'),
  FoodImageOption('bread', 'Bread', '🍞', 'paine toast bakery carbs'),
  FoodImageOption('croissant', 'Croissant', '🥐',
      'croissant corn pastry patiserie breakfast'),
  FoodImageOption(
      'pancakes', 'Pancakes', '🥞', 'clatite pancakes breakfast mic dejun'),
  FoodImageOption('oatmeal', 'Oatmeal', '🥣',
      'ovaz terci porridge oats breakfast mic dejun'),
  FoodImageOption(
      'cereal', 'Cereal', '🥣', 'cereale granola muesli breakfast mic dejun'),
  FoodImageOption('cheese', 'Cheese', '🧀', 'branza dairy cascaval'),
  FoodImageOption('egg', 'Egg', '🥚', 'ou breakfast protein'),
  FoodImageOption('milk', 'Milk', '🥛', 'lapte dairy drink'),
  FoodImageOption('yogurt', 'Yogurt', '🥣', 'iaurt dairy bowl'),
  FoodImageOption('butter', 'Butter', '🧈', 'unt dairy fat grasime'),
  FoodImageOption('nuts', 'Nuts', '🥜',
      'nuci arahide almonds migdale protein healthy fats'),
  FoodImageOption(
      'beans', 'Beans', '🫘', 'fasole legumes leguminoase protein vegan'),
  FoodImageOption('protein_shake', 'Protein shake', '🥤',
      'shake proteic proteine whey zer pudra supliment gym fitness'),
  FoodImageOption(
      'smoothie', 'Smoothie', '🧋', 'smoothie shake fructe drink bautura'),
  FoodImageOption('protein_bar', 'Protein bar', '🍫',
      'baton proteic proteine snack gym fitness'),
  FoodImageOption('chicken', 'Chicken', '🍗', 'pui meat carne protein'),
  FoodImageOption('meat', 'Meat', '🥩', 'carne beef vita steak protein'),
  FoodImageOption('bacon', 'Bacon', '🥓', 'bacon porc meat carne protein'),
  FoodImageOption(
      'sausage', 'Sausage', '🌭', 'carnat crenvursti hot dog meat carne'),
  FoodImageOption('roast', 'Roast', '🍖', 'friptura carne roast meat protein'),
  FoodImageOption('fish', 'Fish', '🐟', 'peste seafood protein'),
  FoodImageOption('shrimp', 'Shrimp', '🍤', 'creveti seafood protein'),
  FoodImageOption('rice', 'Rice', '🍚', 'orez grains carbs'),
  FoodImageOption('pasta', 'Pasta', '🍝', 'paste spaghetti noodles carbs'),
  FoodImageOption('wrap', 'Wrap', '🌯', 'wrap burrito lipie shaorma tortilla'),
  FoodImageOption('sushi', 'Sushi', '🍣', 'sushi japanese peste rice orez'),
  FoodImageOption('ramen', 'Ramen', '🍜', 'ramen noodles taitei supa asian'),
  FoodImageOption('curry', 'Curry', '🍛', 'curry indian orez rice spicy'),
  FoodImageOption('pizza', 'Pizza', '🍕', 'pizza fast food'),
  FoodImageOption('burger', 'Burger', '🍔', 'burger hamburger fast food'),
  FoodImageOption('salad', 'Salad', '🥗', 'salata vegetables healthy'),
  FoodImageOption('soup', 'Soup', '🍲', 'supa ciorba stew bowl'),
  FoodImageOption('sandwich', 'Sandwich', '🥪', 'sandvis bread lunch'),
  FoodImageOption('taco', 'Taco', '🌮', 'taco mexican fast food'),
  FoodImageOption('pretzel', 'Pretzel', '🥨', 'covrig snack bakery'),
  FoodImageOption('popcorn', 'Popcorn', '🍿', 'floricele porumb snack'),
  FoodImageOption(
      'chocolate', 'Chocolate', '🍫', 'ciocolata cacao sweet dulce'),
  FoodImageOption(
      'cookie', 'Cookie', '🍪', 'fursec biscuit cookie sweet dulce'),
  FoodImageOption(
      'cake', 'Cake', '🍰', 'tort prajitura cake dessert sweet dulce'),
  FoodImageOption(
      'ice_cream', 'Ice cream', '🍨', 'inghetata gelato dessert sweet dulce'),
  FoodImageOption('honey', 'Honey', '🍯', 'miere sweet dulce natural'),
  FoodImageOption('coffee', 'Coffee', '☕', 'cafea drink beverage'),
  FoodImageOption('tea', 'Tea', '🍵', 'ceai drink beverage bautura'),
  FoodImageOption('juice', 'Juice', '🧃', 'suc fruit drink beverage bautura'),
  FoodImageOption('water', 'Water', '💧', 'apa drink beverage'),
  FoodImageOption('dessert', 'Dessert', '🧁', 'desert prajitura sweet cake'),
];
