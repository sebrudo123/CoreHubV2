/// Library tabs available from the dashboard.
enum LibraryFilter {
  recent('Recientes'),
  consoles('Consolas / Emuladores'),
  android('Juegos Android');

  const LibraryFilter(this.label);

  final String label;
}
