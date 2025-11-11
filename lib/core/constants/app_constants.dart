class AppConstants {
  // App Info
  static const String appName = 'Control Financiero';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String transactionsCollection = 'transacciones';
  static const String cardsCollection = 'tarjetas';
  static const String usersCollection = 'users';
  
  // Categories
  static const List<Map<String, String>> expenseCategories = [
    {'value': 'alimentacion', 'label': '🍽️ Alimentación'},
    {'value': 'transporte', 'label': '🚗 Transporte'},
    {'value': 'vivienda', 'label': '🏠 Vivienda'},
    {'value': 'ocio', 'label': '🎮 Ocio'},
    {'value': 'salud', 'label': '⚕️ Salud'},
    {'value': 'educacion', 'label': '📚 Educación'},
    {'value': 'servicios', 'label': '💡 Servicios'},
    {'value': 'otros', 'label': '📦 Otros'},
  ];
  
  static const List<Map<String, String>> incomeCategories = [
    {'value': 'salario', 'label': '💼 Salario'},
    {'value': 'freelance', 'label': '💻 Freelance'},
    {'value': 'inversion', 'label': '📈 Inversión'},
    {'value': 'regalo', 'label': '🎁 Regalo'},
    {'value': 'venta', 'label': '🏷️ Venta'},
    {'value': 'reembolso', 'label': '💰 Reembolso'},
    {'value': 'otros', 'label': '📦 Otros'},
  ];
  
  static const List<Map<String, String>> paymentMethods = [
    {'value': 'efectivo', 'label': '💵 Efectivo'},
    {'value': 'debito', 'label': '💳 Débito'},
    {'value': 'credito', 'label': '💳 Crédito'},
    {'value': 'transferencia', 'label': '🏦 Transferencia'},
  ];
  
  static const List<Map<String, String>> frequencies = [
    {'value': 'semanal', 'label': '📅 Semanal'},
    {'value': 'quincenal', 'label': '📅 Quincenal'},
    {'value': 'mensual', 'label': '📅 Mensual'},
    {'value': 'anual', 'label': '📅 Anual'},
  ];
}