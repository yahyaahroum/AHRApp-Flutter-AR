import 'dart:convert';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'Services/TransactionsService.dart';
import 'environement/env.sample.dart';

class ImagesTransaction extends StatefulWidget {
  final int idTransaction;
  const ImagesTransaction( {Key? key, required this.idTransaction}) : super(key: key);

  @override
  _ImagesTransaction createState() => _ImagesTransaction(idTransaction);
}

class _ImagesTransaction extends State<ImagesTransaction> {
  XFile? image;
  List _images = [];

  int idTransaction;

  _ImagesTransaction(this.idTransaction);
  //we can upload image from camera or from gallery based on parameter
  Future sendImage(BuildContext context,ImageSource media,int idTransaction) async {
    await TransactionsServices.addImageByTransaction(context,media, idTransaction);
  }

  Future getImageServer() async {
    try{

      final response = await TransactionsServices.getImagesByTransaction(idTransaction);

        final data = response;

        setState(() {
          _images = data;
        });


    }catch(e){

      print(e);

    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getImageServer();
  }

  //show popup dialog
  Future myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('الرجاء اختيار الصورة'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () async {
                      Navigator.pop(context);
                     await sendImage(context,ImageSource.gallery,idTransaction);

                         getImageServer();

                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('من المعرض'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      sendImage(context,ImageSource.camera,idTransaction);
                      getImageServer();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('من الكاميرا'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    return getImageServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('صور المعاملة'),
          centerTitle: true,
          iconTheme: const IconThemeData(
              color:Colors.orange
          ),
          backgroundColor: Colors.grey[200],
          titleTextStyle: const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 17),
          actions: [
            IconButton(
              onPressed: () async{
               await myAlert();
                 initState();
              }
              ,
              icon: Icon(Icons.upload),
            )
          ],
        ),
        body: _images.length != 0 ?
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
            ),
            itemCount: _images.length,
            itemBuilder: (_, index){
              return
                Padding(
                padding: EdgeInsets.all(10),
                child:
                PhotoView(
                  imageProvider: NetworkImage('${Env.URL_PREFIX}/uploads/images_transaction/'+_images[index]['image']),
                )
              );
            }
        ) : Center(child: Text("لا توجد صورة",style: TextStyle(fontSize: 18),),)
    );
  }
}