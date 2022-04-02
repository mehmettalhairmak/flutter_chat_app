class Errors {
  static String showError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "Bu e-posta adresi zaten kullanımda, lütfen farklı bir e-posta adresi kullanınız";
      case 'user-not-found':
        return "Sistemde böyle bir kullanıcı bulunmamaktadır.";
      default:
        return "Bir hata oluştu";
    }
  }
}
