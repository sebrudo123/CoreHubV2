/// Scraped metadata for a game (box art, logo, synopsis, etc.).
class GameMetadata {
  const GameMetadata({
    this.boxArtUrl,
    this.logoUrl,
    this.screenshotUrl,
    this.description,
    this.developer,
    this.publisher,
    this.genre,
    this.releaseDate,
    this.rating,
  });

  final String? boxArtUrl;
  final String? logoUrl;
  final String? screenshotUrl;
  final String? description;
  final String? developer;
  final String? publisher;
  final String? genre;
  final String? releaseDate;
  final double? rating;

  static const GameMetadata empty = GameMetadata();

  bool get isEmpty =>
      boxArtUrl == null &&
      logoUrl == null &&
      screenshotUrl == null &&
      description == null &&
      developer == null &&
      publisher == null &&
      genre == null &&
      releaseDate == null &&
      rating == null;

  bool get isNotEmpty => !isEmpty;

  GameMetadata copyWith({
    String? boxArtUrl,
    String? logoUrl,
    String? screenshotUrl,
    String? description,
    String? developer,
    String? publisher,
    String? genre,
    String? releaseDate,
    double? rating,
  }) {
    return GameMetadata(
      boxArtUrl: boxArtUrl ?? this.boxArtUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      screenshotUrl: screenshotUrl ?? this.screenshotUrl,
      description: description ?? this.description,
      developer: developer ?? this.developer,
      publisher: publisher ?? this.publisher,
      genre: genre ?? this.genre,
      releaseDate: releaseDate ?? this.releaseDate,
      rating: rating ?? this.rating,
    );
  }
}
