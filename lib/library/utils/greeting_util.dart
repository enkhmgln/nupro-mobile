class GreetingUtil {
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Өглөөний мэнд';
    } else if (hour >= 12 && hour < 18) {
      return 'Өдрийн мэнд';
    } else if (hour >= 18 && hour < 22) {
      return 'Оройн мэнд';
    } else {
      return 'Шөнийн мэнд';
    }
  }
}
