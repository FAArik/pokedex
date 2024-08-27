import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  PokemonListTile({required this.pokemonUrl, super.key});

  final String pokemonUrl;

  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonProvider);
    return pokemon.when(
      data: (data) => _tile(context, false, data),
      error: (err, stackTrace) {
        return Text('Error: $err');
      },
      loading: () => _tile(context, true, null),
    );
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : const CircleAvatar(),
        title: Text(pokemon != null
            ? pokemon.name!.toUpperCase()
            : 'Currently loading name for pokemon'),
        subtitle: Text("Has ${pokemon?.moves?.length.toString()} moves"),
        trailing: IconButton(
          onPressed: () {
            if (_favoritePokemons.contains(pokemonUrl)) {
              _favoritePokemonProvider.removeFavoritePokemon(pokemonUrl);
            } else {
              _favoritePokemonProvider.addFavoritePokemon(pokemonUrl);
            }
          },
          icon: _favoritePokemons.contains(pokemonUrl)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.favorite_border,
                  color: Colors.black38,
                ),
        ),
      ),
    );
  }
}
