import 'package:example5/Example6/data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:example5/Example6/models.dart';

enum FavoriteStatus {
  all,
  favorite,
  nonFavorite,
}

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.all,
);

final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

final favoriteFilmsProvider = Provider((ref) {
  final favoriteFilms =
      ref.watch(allFilmsProvider).where((films) => films.isFavorite);
  return favoriteFilms;
});

final notFavoriteFilmsProvider = Provider((ref) {
  final nonFavoriteFilms =
      ref.watch(allFilmsProvider).where((films) => !films.isFavorite);
  return nonFavoriteFilms;
});

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allfilms);

  void update(Film film, bool isFavorite) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavorite: isFavorite)
            : thisFilm)
        .toList(); 
  }
}
