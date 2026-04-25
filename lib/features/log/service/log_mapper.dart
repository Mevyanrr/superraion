class LogMapper {

  static Map<String, int> mapFood(List<String> categories, String detail) {
    return {
      'susu':    categories.contains('Dairy') ? 1 : 0,
      'protein': categories.contains('Protein') ? 1 : 0,
      'sayur':   categories.contains('Refined') ? 1 : 0,
      'karbo':   categories.contains('Carbs') ? 1 : 0,
      'fastfood': categories.contains('Fastfood') ? 1 : 0,
      'sweets':  categories.contains('Sweets') ? 1 : 0,
      'fried':   categories.contains('Fried') ? 1 : 0,
      'drinks':  categories.contains('Drinks') ? 1 : 0,
    };
  }

  static Map<String, double> mapSymptoms(Map<String, String?> signals) {
    return {
      'skin_score':      _acneScore(signals['Acne']),
      'hair_loss_score': _levelScore(signals['Hair Loss']),
      'bloating_score':  _levelScore(signals['Bloating Level']),
      'mood_score':      _moodScore(signals['Mood']),
      'energy_score':    _energyScore(signals['Energy Level']),
      'weight_score':    _levelScore(signals['Weight']),
      'digestion_score': _digestionScore(signals['Digestion']),
    };
  }

  static Map<String, dynamic> mapHabits({
    required double durasiJam,
    required int waterMl,
    String? stresshigh,
    String? moderate,
    String? relaxed,
    String? active,
    String? light,
    String? none,
    String? energyhigh,
    String? energylow,
  }) {
    return {
      'sleep_hours':    durasiJam,
      'water_glasses':  (waterMl / 250).round(),
      'stress_score':   _stressScore(stresshigh, moderate, relaxed),
      'activity_score': _activityScore(active, light, none),
    };
  }


  static double _acneScore(String? val) {
    switch (val) {
      case 'Clear':  return 0.0;
      case 'Mild':   return 1.0;
      case 'Severe': return 2.0;
      default:       return 0.0;
    }
  }

  static double _levelScore(String? val) {
    switch (val) {
      case 'None':
      case 'Normal':
      case 'Stable': return 0.0;
      case 'Mild':
      case 'Slight':
      case 'Increased':
      case 'Irregular': return 1.0;
      case 'Severe':
      case 'Heavy':
      case 'High':
      case 'Diarrhea': return 2.0;
      default: return 0.0;
    }
  }

  static double _moodScore(String? val) {
    switch (val) {
      case 'Stable':      return 0.0;
      case 'Fluctuating': return 1.0;
      case 'Bad':         return 2.0;
      default:            return 0.0;
    }
  }

  static double _energyScore(String? val) {
    switch (val) {
      case 'High': return 2.0;
      case 'Okay': return 1.0;
      case 'Low':  return 0.0;
      default:     return 0.0;
    }
  }

  static double _digestionScore(String? val) {
    switch (val) {
      case 'Normal':    return 0.0;
      case 'Irregular': return 1.0;
      case 'Diarrhea':  return 2.0;
      default:          return 0.0;
    }
  }

  static double _stressScore(
      String? high, String? moderate, String? relaxed) {
    if (high != null) return 2.0;
    if (moderate != null) return 1.0;
    if (relaxed != null) return 0.0;
    return 0.0;
  }

  static double _activityScore(
      String? active, String? light, String? none) {
    if (active != null) return 2.0;
    if (light != null) return 1.0;
    if (none != null) return 0.0;
    return 0.0;
  }
}