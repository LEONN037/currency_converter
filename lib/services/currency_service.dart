import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {

  Future<double?> fetchExchangeRate(String base, String target) async {
    final uri = Uri.parse('https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_RwrnQVaiTY1aq9Iak2f1O2E5KRuWhvefr3z2URPx&base_currency=$base');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final rate = json['data'][target];
        return rate != null ? rate.toDouble() : null;
      } else {
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
