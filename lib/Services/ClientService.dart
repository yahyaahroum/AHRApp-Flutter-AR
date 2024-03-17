import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_gen_l10n_example/models/client.dart';

import '../environement/env.sample.dart';

class Services {
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_CLIENT_ACTION = 'ADD_CLIENT';
  static const _UPDATE_CLIENT_ACTION = 'UPDATE_CLIENT';
  static const _DELETE_CLIENT_ACTION = 'DELETE_CLIENT';
  static const _FIND_CLIENT_BYID_ACTION = 'FIND_CLIENT_BYID';

  static Future<List> getClients() async {
    final response = await http.post(
        Uri.parse("${Env.URL_PREFIX}/ClientsService.php"),body: {
          'action':_GET_ALL_ACTION
    });
    return jsonDecode(response.body);
  }

  /*static Future<List> FindClientById(int id) async {
    final response = await http.post(Uri.parse("${Env.URL_PREFIX}/Clients/findClientById.php"),body: {
      "id": id
    });
    return jsonDecode(response.body);

  }*/
  static Future<Client> FindClientById(int userId) async {
    final response = await http.post(
        Uri.parse("${Env.URL_PREFIX}/ClientsService.php"),body: {
          'action':_FIND_CLIENT_BYID_ACTION,
          'id':userId.toString()
    });
    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static List<Client> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Client>((json) => Client.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future addClient(String nom, String prenom, String tel,
      String ville) async {
    return await http.post(
        Uri.parse("${Env.URL_PREFIX}/ClientsService.php"),
        body: {
          "action":_ADD_CLIENT_ACTION,
          "nom": nom,
          "prenom": prenom,
          "tel": tel,
          "ville": ville,
        }
    );
  }

  // Method to update an Employee in Database...
  static Future updateClient(int id, String nom, String prenom, String tel,
      String ville) async {
    await http.post(
        Uri.parse("${Env.URL_PREFIX}/ClientsService.php"),
        body: {
          "action": _UPDATE_CLIENT_ACTION,
          "id": id.toString(),
          "nom": nom,
          "prenom": prenom,
          "tel": tel,
          "ville": ville,
        }
    );
  }

  // Method to Delete an Employee from Database...
/*  static Future<String> deleteClient(int userId) async {
    try {
      print('xxxxxxxxxxxxxxxxxxxxxxxxx');
      final response = await http.get(Uri.parse('${Env.URL_PREFIX}/Clients/deleteClient.php?id=$userId'));
     */ /* final response = await http.post(Uri.parse('${Env.URL_PREFIX}/Clients/deleteClient.php'),body: {
        "action":_DELETE_CLIENT_ACTION,
        "id":userId,
      });*/ /*
      print('deleteClient Response: ${response.body}');

      if (200 == response.statusCode) {
        return json.decode(response.body);
      } else {
        return "statusCode error";
      }
    } catch (e) {
      return e
          .toString(); // returning just an "error" string to keep this simple...
    }
  }*/
  static Future<void> deleteClient(int id) async {
    final url = "${Env.URL_PREFIX}/ClientsService.php";
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': id.toString(),
        'action':_DELETE_CLIENT_ACTION
      },
    );
/*print (response.statusCode);
    if (response.statusCode == 200) {
      print('Record deleted successfully');
    } else {
      print('Error deleting record: ${response.body}');
    }*/
  }
}