String getCardType(String cardNumber) {
  // Remove any non-digit characters from the card number
  String cleanedNumber = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

  print("card Number${cleanedNumber}");

  // Regular expressions to match card patterns
  RegExp visaPattern = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  RegExp mastercardPattern = RegExp(r'^5[1-5][0-9]{14}$');
  RegExp amexPattern = RegExp(r'^3[47][0-9]{13}$');
  RegExp discoverPattern = RegExp(r'^6(?:011|5[0-9]{2})[0-9]{12}$');
  RegExp dinersClubPattern = RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$');
  RegExp jcbPattern = RegExp(r'^(?:2131|1800|35[0-9]{3})[0-9]{11}$');
  RegExp rupayPattern = RegExp(r'^6[0-9]{15}$');

  // Check the card number against each pattern and return the corresponding card type
  if (visaPattern.hasMatch(cleanedNumber)) {
    return 'Visa';
  } else if (mastercardPattern.hasMatch(cleanedNumber)) {
    return 'Mastercard';
  } else if (amexPattern.hasMatch(cleanedNumber)) {
    return 'American Express';
  } else if (discoverPattern.hasMatch(cleanedNumber)) {
    return 'Discover';
  } else if (dinersClubPattern.hasMatch(cleanedNumber)) {
    return 'Diners Club';
  } else if (jcbPattern.hasMatch(cleanedNumber)) {
    return 'JCB';
  } else if (rupayPattern.hasMatch(cleanedNumber)) {
    return 'RuPay';
  } else {
    return 'Unknown';
  }
}
