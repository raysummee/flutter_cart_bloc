import 'package:http/http.dart' as http;

class ProductProvider {
  Future<String?> getProducts() async {
    var response =
        await http.get(Uri.parse("https://fakestoreapi.com/products"));

    if (response.statusCode == 200) {
      return response.body;
    }

    return null;
  }
}
