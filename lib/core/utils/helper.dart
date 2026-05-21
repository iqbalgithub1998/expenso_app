String formatPhoneNumber(String phone) {
  return phone.replaceAll(RegExp(r'[^0-9]'), '').replaceFirst('91', '');
}
