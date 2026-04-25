enum InsightType { warning, info }

class BodyInsightItem {
  final String text; // Teks mentah dari AI
  final InsightType type;

  BodyInsightItem({required this.text, required this.type});
}