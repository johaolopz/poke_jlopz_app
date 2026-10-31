import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PokeApp());
}

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const ElementSelectionScreen(),
    );
  }
}

class PokemonElement {
  final String title;
  final String apiType;
  final int representativePokemonId;
  final String representativeName;
  final Color color;

  const PokemonElement({
    required this.title,
    required this.apiType,
    required this.representativePokemonId,
    required this.representativeName,
    required this.color,
  });

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$representativePokemonId.png';

  String get gifUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/$representativePokemonId.gif';
}

class ElementSelectionScreen extends StatefulWidget {
  const ElementSelectionScreen({super.key});

  static const List<PokemonElement> elements = [
    PokemonElement(
      title: 'Agua',
      apiType: 'water',
      representativePokemonId: 7, // Squirtle
      representativeName: 'Squirtle',
      color: Colors.blue,
    ),
    PokemonElement(
      title: 'Fuego',
      apiType: 'fire',
      representativePokemonId: 4, // Charmander
      representativeName: 'Charmander',
      color: Colors.deepOrange,
    ),
    PokemonElement(
      title: 'Tierra',
      apiType: 'ground',
      representativePokemonId: 27, // Sandshrew
      representativeName: 'Sandshrew',
      color: Colors.brown,
    ),
    PokemonElement(
      title: 'Aire',
      apiType: 'flying',
      representativePokemonId: 18, // Pidgeot
      representativeName: 'Pidgeot',
      color: Colors.teal,
    ),
  ];

  @override
  State<ElementSelectionScreen> createState() => _ElementSelectionScreenState();
}

class _ElementSelectionScreenState extends State<ElementSelectionScreen> {
  bool isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    // Loader inicial de Pikachu con imagen estática durante 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isInitialLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: isInitialLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
                    height: 140,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.catching_pokemon, size: 80, color: Colors.amber),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Cargando Pokédex...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Selecciona un elemento para ver sus Pokémon:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: GridView.builder(
                        itemCount: ElementSelectionScreen.elements.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final element =
                              ElementSelectionScreen.elements[index];
                          return ElementCard(
                            element: element,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PokemonListScreen(
                                    element: element,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ElementCard extends StatelessWidget {
  final PokemonElement element;
  final VoidCallback onTap;

  const ElementCard({
    super.key,
    required this.element,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: element.color.withValues(alpha: 0.3), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: element.color.withValues(alpha: 0.2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                element.color.withValues(alpha: 0.1),
                Colors.white,
              ],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  element.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.catching_pokemon,
                    size: 60,
                    color: element.color,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: element.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  element.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: element.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  final PokemonElement element;

  const PokemonListScreen({
    super.key,
    required this.element,
  });

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> pokemonList = [];
  bool isLoading = true;
  String? errorMessage;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressController.forward();
    fetchPokemonByType();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemonByType() async {
    try {
      final results = await Future.wait([
        http.get(
          Uri.parse('https://pokeapi.co/api/v2/type/${widget.element.apiType}'),
        ),
        Future.delayed(const Duration(seconds: 3)),
      ]);

      if (!mounted) return;

      final response = results[0] as http.Response;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rawPokemonList = (data['pokemon'] as List<dynamic>?) ?? [];

        final first20 = rawPokemonList
            .take(20)
            .map((entry) => entry['pokemon'])
            .toList();

        setState(() {
          pokemonList = first20;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al cargar los Pokémon';
          isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'No se pudo conectar a la PokéAPI';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokémon: ${widget.element.title}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.element.color,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          widget.element.gifUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Image.network(
                            widget.element.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.catching_pokemon,
                              size: 60,
                              color: widget.element.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            minHeight: 10,
                            backgroundColor:
                                widget.element.color.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.element.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(_progressController.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: widget.element.color,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          _progressController.reset();
                          _progressController.forward();
                          fetchPokemonByType();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: pokemonList.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemonList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: widget.element.color,
                        child: const Icon(Icons.catching_pokemon, color: Colors.white),
                      ),
                      title: Text(
                        pokemon['name'].toString().toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Elemento ${widget.element.title}'),
                      trailing: Text('#${index + 1}'),
                    );
                  },
                ),
    );
  }
}
