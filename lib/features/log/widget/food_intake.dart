import 'package:flutter/material.dart';

class FoodIntake extends StatefulWidget {
  final void Function(List<String> categories, String detail)? onChanged;
  const FoodIntake({super.key, this.onChanged});

  @override
  State<FoodIntake> createState() => _FoodIntakeState();
}

class _FoodIntakeState extends State<FoodIntake> {
  final List<String> _categories = [
    'Protein', 'Refined', 'Supplements',
    'Carbs', 'Drinks', 'Fastfood',
    'Sweets', 'Dairy', 'Fried',
  ];
  final Set<String> _selected = {};
  final Set<String> _pressing = {};
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged?.call(_selected.toList(), _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.restaurant_menu,
                    color: Color(0xFFE91E63), size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Food Intake',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
            ],
          ),

          const SizedBox(height: 20),
          const Text('Food Categories',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                  color: Color(0xFF111827))),
          const SizedBox(height: 12),

          // Chips
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selected.contains(cat);
              final isPressing = _pressing.contains(cat);

              Color bg, border, text;
              if (isPressing) {
                bg = const Color(0xFFE91E63);
                border = const Color(0xFFE91E63);
                text = Colors.white;
              } else if (isSelected) {
                bg = const Color(0xFFFCE4EC);
                border = const Color(0xFFE91E63);
                text = const Color(0xFFE91E63);
              } else {
                bg = const Color(0xFFF3F4F6);
                border = const Color(0xFFD1D5DB);
                text = const Color(0xFF6B7280);
              }

              return GestureDetector(
                onTapDown: (_) => setState(() => _pressing.add(cat)),
                onTapUp: (_) => setState(() {
                  _pressing.remove(cat);
                  isSelected ? _selected.remove(cat) : _selected.add(cat);
                  _notify();
                }),
                onTapCancel: () => setState(() => _pressing.remove(cat)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Text(cat,
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w500, color: text)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          RichText(
            text: const TextSpan(
              text: 'Add Food Details ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                  color: Color(0xFF111827)),
              children: [
                TextSpan(text: '(optional)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,
                        color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _controller,
            onChanged: (_) => _notify(),
            maxLines: 3,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
            decoration: InputDecoration(
              hintText: 'What are you eating?',
              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFD1D5DB)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE91E63), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}