int calculateColumns(int totalItems) {
  if (totalItems < 16) {
    return (totalItems / 4).ceil();
  }
  return 4;
}
