import 'package:flutter/material.dart';

class BodySignals extends StatefulWidget {
  final void Function(Map<String, String?> signals)? onChanged;
  const BodySignals({super.key, this.onChanged});

  @override
  State<BodySignals> createState() => _BodySignalsState();
}

class _BodySignalsState extends State<BodySignals> {
  final Map<String, List<_Option>> _options = {
    'Bloating Level': [
      _Option('None', '😊'), _Option('Mild', '😐'), _Option('Severe', '😣'),
    ],
    'Energy Level': [
      _Option('Low', '🪫'), _Option('Okay', '⚡'), _Option('High', '🔋'),
    ],
    'Acne': [
      _Option('Clear', '✨'), _Option('Mild', '😕'), _Option('Severe', '😞'),
    ],
    'Mood': [
      _Option('Stable', '😊'), _Option('Fluctuating', '😶'), _Option('Bad', '😔'),
    ],
    'Hair Loss': [
      _Option('Normal', '💆'), _Option('Increased', '😟'), _Option('Heavy', '😰'),
    ],
    'Weight': [
      _Option('Stable', '⚖️'), _Option('Slight', '📉'), _Option('High', '📈'),
    ],
    'Digestion': [
      _Option('Normal', '✅'), _Option('Irregular', '⚠️'), _Option('Diarrhea', '🤢'),
    ],
  };

  final Map<String, int?> _selected = {};

  void _notify() {
    final result = _options.map((key, opts) => MapEntry(
      key,
      _selected[key] != null ? opts[_selected[key]!].label : null,
    ));
    widget.onChanged?.call(result);
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
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.monitor_heart_outlined,
                    color: Color(0xFF8B5CF6), size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Body Signals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
            ],
          ),

          const SizedBox(height: 20),

          ..._options.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key,
                    style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111827))),
                const SizedBox(height: 10),
                Row(
                  children: entry.value.asMap().entries.map((e) {
                    final idx = e.key;
                    final opt = e.value;
                    final isSelected = _selected[entry.key] == idx;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selected[entry.key] = isSelected ? null : idx;
                          _notify();
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: EdgeInsets.only(
                              right: idx < entry.value.length - 1 ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEDE9FE)
                                : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFFE5E7EB),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(opt.emoji,
                                  style: const TextStyle(fontSize: 24)),
                              const SizedBox(height: 4),
                              Text(opt.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? const Color(0xFF8B5CF6)
                                        : const Color(0xFF6B7280),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _Option {
  final String label;
  final String emoji;
  const _Option(this.label, this.emoji);
}