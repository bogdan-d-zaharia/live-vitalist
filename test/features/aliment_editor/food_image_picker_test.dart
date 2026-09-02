import 'package:flutter_test/flutter_test.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/food_image_picker.dart';

void main() {
  group('food image suggestions', () {
    test('matches Romanian and English names', () {
      expect(suggestFoodImageForName('shake proteic')?.key, 'protein_shake');
      expect(suggestFoodImageForName('protein shake')?.key, 'protein_shake');
      expect(suggestFoodImageForName('piept de pui')?.key, 'chicken');
      expect(suggestFoodImageForName('ovăz')?.key, 'oatmeal');
    });

    test('matches partial names and small typos', () {
      expect(suggestFoodImageForName('banan')?.key, 'banana');
      expect(suggestFoodImageForName('bananna')?.key, 'banana');
      expect(suggestFoodImageForName('ou')?.key, 'egg');
    });

    test('does not guess unrelated names', () {
      expect(suggestFoodImageForName('aliment necunoscut xyz'), isNull);
      expect(suggestFoodImageForName('a'), isNull);
    });
  });
}
