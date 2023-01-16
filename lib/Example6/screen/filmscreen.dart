import 'package:example5/Example6/models.dart';
import 'package:example5/Example6/providers/filmsProvider.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsList({required this.provider, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) {
        final film = films.elementAt(index);
        final favoriteIcon = film.isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border);
        return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
                onPressed: () {
                  final isfavorite = !film.isFavorite;
                  ref.read(allFilmsProvider.notifier).update(film, isfavorite);
                },
                icon: favoriteIcon));
      },
      itemCount: films.length,
    ));
  }
}

class FilmHomePage extends StatelessWidget {
  const FilmHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Column(children: [
        const FilterWidget(),
        // FilmsList(provider: allFilmsProvider)],
        Consumer(builder: ((context, ref, child) {
          final filter = ref.watch(favoriteStatusProvider);
          switch (filter) {
            case FavoriteStatus.all:
              return FilmsList(provider: allFilmsProvider);

            case FavoriteStatus.favorite:
              return FilmsList(provider: favoriteFilmsProvider);

            case FavoriteStatus.nonFavorite:
              return FilmsList(provider: notFavoriteFilmsProvider);
          }
        }))
      ]),
    );
  }
}

class FilterWidget extends ConsumerWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      value: ref.read(favoriteStatusProvider),
      items: FavoriteStatus.values
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString().split('.').last),
              ))
          .toList(),
      onChanged: (value) =>
          ref.read(favoriteStatusProvider.state).state = value!,
    );
  }
}
