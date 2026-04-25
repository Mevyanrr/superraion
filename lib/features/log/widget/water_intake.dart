import 'package:flutter/material.dart';

class WaterIntake extends StatefulWidget {
  final void Function(int ml)? onChanged;
  const WaterIntake({super.key, this.onChanged});

  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  int _ml = 0;
  final int _goal = 2700;
  final int _step = 250;

  double get _progress => (_ml / _goal).clamp(0.0, 1.0);

  String get _level {
    if (_progress < 0.33) return 'Low';
    if (_progress < 0.66) return 'Medium';
    return 'High';
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

          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.water_drop_outlined,
                    color: Color(0xFF0EA5E9), size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Water Intake',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_level,
                    style: const TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0EA5E9))),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 46, top: 2),
            child: Text('Daily Goal: ${(_goal / 1000).toStringAsFixed(1)}L',
                style: const TextStyle(fontSize: 12,
                    color: Color(0xFF9CA3AF))),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text('$_ml ML Logged',
                style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0EA5E9))),
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0F2FE),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF0EA5E9)),
            ),
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Low • 0 L',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              Text('High • ${(_goal / 1000).toStringAsFixed(1)} L',
                  style: const TextStyle(fontSize: 11,
                      color: Color(0xFF9CA3AF))),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _WaterButton(
                label: '- $_step ML',
                color: const Color(0xFFFF6B8A),
                onTap: () => setState(() {
                  _ml = (_ml - _step).clamp(0, _goal * 2);
                  widget.onChanged?.call(_ml);
                }),
              )),
              const SizedBox(width: 12),
              Expanded(child: _WaterButton(
                label: '+ $_step ML',
                color: const Color(0xFF0EA5E9),
                onTap: () => setState(() {
                  _ml = (_ml + _step).clamp(0, _goal * 2);
                  widget.onChanged?.call(_ml);
                }),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _WaterButton({required this.label, required this.color,
    required this.onTap});

  @override
  State<_WaterButton> createState() => _WaterButtonState();
}

class _WaterButtonState extends State<_WaterButton> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressing = true),
      onTapUp: (_) { setState(() => _pressing = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressing = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _pressing ? widget.color : widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.color.withOpacity(0.4)),
        ),
        child: Center(
          child: Text(widget.label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: _pressing ? Colors.white : widget.color)),
        ),
      ),
    );
  }
}