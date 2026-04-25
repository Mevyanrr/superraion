import 'package:flutter/material.dart';

class HabitIntake extends StatefulWidget {
  final void Function(
      String tidurMulai,
      String tidurSelesai,
      double durasiJam, {
      String? relaxed,
      String? moderate,
      String? stresshigh,
      String? stresslow,
      String? active,
      String? light,
      String? none,
      String? energyhigh,
      String? energylow,
      })? onChanged;
  const HabitIntake({super.key, this.onChanged});

  @override
  State<HabitIntake> createState() => _HabitIntakeState();
}

class _HabitIntakeState extends State<HabitIntake> {
  TimeOfDay _tidurMulai = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _tidurSelesai = const TimeOfDay(hour: 6, minute: 0);
  final Map<String, String?> _aktivitas = {
    'stress_level': null,   // relaxed / moderate / high
    'activity_level': null, // active / light / none
    'energy_level': null,   // high / low
  };

  double get _durasi {
    final mulaiMenit = _tidurMulai.hour * 60 + _tidurMulai.minute;
    final selesaiMenit = _tidurSelesai.hour * 60 + _tidurSelesai.minute;
    final diff = selesaiMenit < mulaiMenit
        ? (1440 - mulaiMenit) + selesaiMenit
        : selesaiMenit - mulaiMenit;
    return diff / 60;
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String get _durasiLabel {
    final jam = _durasi.floor();
    final menit = ((_durasi - jam) * 60).round();
    return menit > 0 ? '${jam}j ${menit}m' : '${jam}j';
  }

  String get _kualitas {
    if (_durasi < 6) return 'Kurang';
    if (_durasi < 8) return 'Cukup';
    return 'Baik';
  }

  Color get _kualitasColor {
    if (_durasi < 6) return const Color(0xFFEF4444);
    if (_durasi < 8) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  void _notify() {
    final stress = _aktivitas['stress_level'];
    final activity = _aktivitas['activity_level'];
    final energy = _aktivitas['energy_level'];

    widget.onChanged?.call(
      _formatTime(_tidurMulai),
      _formatTime(_tidurSelesai),
      _durasi,
      relaxed: stress == 'Relaxed' ? 'Relaxed' : null,
      moderate: stress == 'Moderate' ? 'Moderate' : null,
      stresshigh: stress == 'High' ? 'High' : null,
      stresslow: stress == 'Low' ? 'Low' : null,
      active: activity == 'Active' ? 'Active' : null,
      light: activity == 'Light' ? 'Light' : null,
      none: activity == 'None' ? 'None' : null,
      energyhigh: energy == 'High' ? 'High' : null,
      energylow: energy == 'Low' ? 'Low' : null,
    );
  }

  Future<void> _pickTime(bool isMulai) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isMulai ? _tidurMulai : _tidurSelesai,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF6366F1)),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      isMulai ? _tidurMulai = picked : _tidurSelesai = picked;
      _notify();
    });
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
          // ── Header ──
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bedtime_outlined,
                    color: Color(0xFF6366F1), size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Sleep Habit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kualitasColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_kualitas,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                        color: _kualitasColor)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Durasi ──
          Center(
            child: Column(
              children: [
                Text(_durasiLabel,
                    style: const TextStyle(fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1))),
                const Text('Durasi Tidur',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Time pickers ──
          Row(
            children: [
              Expanded(child: _TimePicker(
                label: 'Mulai Tidur',
                icon: Icons.nights_stay_outlined,
                time: _formatTime(_tidurMulai),
                onTap: () => _pickTime(true),
              )),
              const SizedBox(width: 12),
              Expanded(child: _TimePicker(
                label: 'Bangun',
                icon: Icons.wb_sunny_outlined,
                time: _formatTime(_tidurSelesai),
                onTap: () => _pickTime(false),
              )),
            ],
          ),

          const SizedBox(height: 16),

          // ── Progress bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_durasi / 10).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E7FF),
              valueColor: AlwaysStoppedAnimation<Color>(_kualitasColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Kurang • < 6j',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              Text('Ideal • 8j',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),

          // ── Aktivitas ──
          _AktivitasSection(
            label: 'Stress Level',
            icon: Icons.psychology_outlined,
            options: const ['Relaxed', 'Moderate', 'High'],
            selected: _aktivitas['stress_level'],
            onSelect: (val) => setState(() {
              _aktivitas['stress_level'] = val;
              _notify();
            }),
          ),

          const SizedBox(height: 16),

          _AktivitasSection(
            label: 'Activity Level',
            icon: Icons.directions_run_outlined,
            options: const ['Active', 'Light', 'None'],
            selected: _aktivitas['activity_level'],
            onSelect: (val) => setState(() {
              _aktivitas['activity_level'] = val;
              _notify();
            }),
          ),

          const SizedBox(height: 16),

          _AktivitasSection(
            label: 'Energy Level',
            icon: Icons.bolt_outlined,
            options: const ['High', 'Low'],
            selected: _aktivitas['energy_level'],
            onSelect: (val) => setState(() {
              _aktivitas['energy_level'] = val;
              _notify();
            }),
          ),
        ],
      ),
    );
  }
}

class _AktivitasSection extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> options;
  final String? selected;
  final void Function(String?) onSelect;

  const _AktivitasSection({
    required this.label,
    required this.icon,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF6366F1)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827))),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            final isSelected = selected == opt;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(isSelected ? null : opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(
                      right: opt != options.last ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE0E7FF)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E7EB),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(opt,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : const Color(0xFF6B7280),
                        )),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  const _TimePicker({
    required this.label, required this.time,
    required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDDD6FE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: const Color(0xFF8B5CF6)),
                const SizedBox(width: 4),
                Text(label,
                    style: const TextStyle(fontSize: 11,
                        color: Color(0xFF8B5CF6))),
              ],
            ),
            const SizedBox(height: 4),
            Text(time,
                style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6366F1))),
          ],
        ),
      ),
    );
  }
}