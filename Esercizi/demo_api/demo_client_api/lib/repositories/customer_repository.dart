import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';

class CustomerRepository {
  final String baseUrl = 'http://localhost:3000/customers';

  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse(baseUrl));
    final data = json.decode(response.body) as List;
    return data.map((e) => Customer.fromJson(e)).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    await http.post(Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customer.toJson()));
  }

  Future<void> updateCustomer(Customer customer) async {
    await http.put(Uri.parse('$baseUrl/${customer.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customer.toJson()));
  }

  Future<void> deleteCustomer(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
