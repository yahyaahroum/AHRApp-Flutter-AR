import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen_l10n_example/models/Transaction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen_l10n_example/models/client.dart';
import 'package:image_picker/image_picker.dart';

import '../environement/env.sample.dart';

class TransactionsServices {
  static  String _SERVER = "${Env.URL_PREFIX}/TransactionsService.php";
  static const _GET_ALL_BYTRANSACTION_ACTION = 'GET_ALL_BYTRANSACTION';
  static const _ADD_TRANSACTION_ACTION = 'ADD_TRANSACTION';
  static const _UPDATE_TRANSACTION_ACTION = 'UPDATE_TRANSACTION';
  static const _DELETE_TRANSACTION_ACTION = 'DELETE_TRANSACTION';
  static const _FIND_TRANSACTIONBYID_ACTION = 'FIND_TRANSACTION_BYID';
  static const _GET_ALL_IMAGE_BYTRANSACTION = 'GET_ALL_IMAGE_BYTRANSACTION';
  static const _ADD_IMAGE_BYTRANSACTION = 'ADD_IMAGE_BYTRANSACTION';
  static ImagePicker picker = ImagePicker();

  static Future<List> getTransactions(int idClient) async {
    final response = await http.post(
        Uri.parse(_SERVER),body: {
          'action':_GET_ALL_BYTRANSACTION_ACTION,
          'idClient':idClient.toString()
    });

    return jsonDecode(response.body);
  }
  static Future<List> getImagesByTransaction(int idTransaction) async {
    final response = await http.post(
        Uri.parse(_SERVER),body: {
      'action':_GET_ALL_IMAGE_BYTRANSACTION,
      'idTransaction':idTransaction.toString()
    });

    return jsonDecode(response.body);
  }
  static Future addImageByTransaction(BuildContext context,ImageSource media,int idTransaction) async {

    var img = await picker.pickImage(source: media);

    var request = http.MultipartRequest('POST', Uri.parse(_SERVER));

    if(img != null){

      var pic = await http.MultipartFile.fromPath("image", img.path);

      request.files.add(pic);
      request.fields['action'] = _ADD_IMAGE_BYTRANSACTION;
      request.fields['idTransaction'] = idTransaction.toString();

    /*  request.files.add(await http.MultipartFile.fromPath(
        'file1',
        'path/to/file1',
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'file2',
        'path/to/file2',
      ));*/
      await request.send().then((result) {

        http.Response.fromStream(result).then((response) {

          var message = jsonDecode(response.body);

          // show snackbar if input data successfully
          final snackBar = SnackBar(content: Text(message['message']));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

      }).catchError((e) {

        print(e);

      });
    }

  }

  static Future<Transaction> FindTransactionById(int idTransaction) async {
    final response = await http.post(
        Uri.parse(_SERVER),body: {
      'action':_FIND_TRANSACTIONBYID_ACTION,
      'id':idTransaction.toString()
    });
    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }


  // Method to add employee to the database...




  static Future addTransaction(String dateT, String typeT,String genreT, String valeurT,String imageT,int idClient) async {
    return await http.post(
        Uri.parse(_SERVER),
        body: {
          "action":_ADD_TRANSACTION_ACTION,
          "dateT":dateT,
          "typeT":typeT,
          "genreT":genreT,
          "valeurT":valeurT,
          "imageT":imageT,
          "clientT":idClient.toString()
        }
    );
  }


  static Future updateTransaction(int id, String dateT, String typeT,String genreT, String valeurT) async {
    await http.post(
        Uri.parse(_SERVER),
        body: {
          "action": _UPDATE_TRANSACTION_ACTION,
          "id": id.toString(),
          "dateT":dateT,
          "typeT":typeT,
          "genreT":genreT,
          "valeurT":valeurT,
        }
    );
  }



  static Future<void> deleteTransaction(int id) async {

    final response = await http.post(
      Uri.parse(_SERVER),
      body: {
        'id': id.toString(),
        'action':_DELETE_TRANSACTION_ACTION
      },
    );
  }
}