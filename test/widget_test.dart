import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:poke_jlopz_app/main.dart';

void main() {
  testWidgets(
      'Initial image loader with spinner, element screen, and gif + linear progress bar on selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PokeApp());

    // 1. Initial screen displays Pikachu static image and CircularProgressIndicator
    expect(find.text('Cargando Pokédex...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 2. Wait 5 seconds for initial loader to complete
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();

    // 3. Now the 4 element cards should be visible
    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.text('Agua'), findsOneWidget);
    expect(find.text('Fuego'), findsOneWidget);
    expect(find.text('Tierra'), findsOneWidget);
    expect(find.text('Aire'), findsOneWidget);

    // 4. Tap on 'Agua' card
    await tester.tap(find.text('Agua'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // 5. Verify navigation to PokemonListScreen:
    // CircularProgressIndicator is gone, but LinearProgressIndicator is present
    expect(find.text('Pokémon: Agua'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    // 6. Advance past the 3-second minimum timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });

  testWidgets('PokemonDetailScreen renders pokemon name and details card correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PokemonDetailScreen(
          pokemonName: 'squirtle',
          pokemonUrl: 'https://pokeapi.co/api/v2/pokemon/7/',
          elementColor: Colors.blue,
          elementTitle: 'Agua',
        ),
      ),
    );

    // Verify AppBar shows pokemon name
    expect(find.text('SQUIRTLE'), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
