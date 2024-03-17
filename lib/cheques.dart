
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:getwidget/getwidget.dart';
import 'Components/my_app_bar.dart';
import 'Services/ClientService.dart';
import 'detail_client.dart';
class Cheques extends StatefulWidget {
  const Cheques({Key? key}) : super(key: key);
  final String title = 'User Data Table';
  @override
  _ChequesState createState() => _ChequesState();
}
class _ChequesState extends State<Cheques> {
  final studentListKey = GlobalKey<_ChequesState>();
  List listeClt=[];
  String searchString="";
  TextEditingController nomC=TextEditingController();
  TextEditingController prenomC=TextEditingController();
  TextEditingController villeC=TextEditingController();
  TextEditingController telC=TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  //List items= [];



  @override
  void initState(){
    nomC = TextEditingController();
    prenomC = TextEditingController();
    villeC = TextEditingController();
    telC = TextEditingController();
    getClients();
    super.initState();
  }

  void getClientByID(int id){
    Services.FindClientById(id).then((c) {
      nomC.text = c.nom;
      prenomC.text = c.prenom;
      villeC.text=c.ville;
      telC.text=c.tel;
    });
  }
  _addClient() async{
    await Services.addClient(nomC.text, prenomC.text,telC.text, villeC.text);
    reloadData();
    clearValues();
  }
  getClients() async{
    return Services.getClients();
  }
  // Method to clear TextField values
  clearValues() {
    nomC.clear();
    prenomC.clear();
    telC.clear();
    villeC.clear();
  }

  void updateClient(int id) async {
    await Services.updateClient(id,nomC.text, prenomC.text, telC.text, villeC.text);
    clearValues();
    reloadData();
  }
  void deleteClient(int id) {

    PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: "أهلا",
      message: "هل أنت متأكد أنك تريد حذف هذا الزبون؟",
      confirmButtonText: "تأكيد",
      cancelButtonText: "إلغاء",
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () async {

        await Services.deleteClient(id);
        reloadData();
      },
      panaraDialogType: PanaraDialogType.warning,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const my_app_bar( title: 'الزبائن',),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            clearValues();
            _modalAddClient( context);
          },

          tooltip: 'إضافة زبون جديد',
          child:  const Icon(Icons.add),
        ), // This trailing comma makes au
        body:
        Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child:
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'بحث',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),

              ),
              Expanded(child:

              FutureBuilder(
                  future: getClients(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: Colors.orange));

                    } else {
                      List filteredData = snapshot.data.where((item) =>
                      item['nom'].toLowerCase().contains(searchString) ||
                          item['prenom'].toLowerCase().contains(searchString) ||
                          item['tel'].toLowerCase().contains(searchString) ||
                          item['ville'].toLowerCase().contains(searchString))
                          .toList();


                      // Render student lists
                      return
                        ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return
                              Slidable(
                                  key: const ValueKey(0),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (contextD) async {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailClient(
                                                      idClient: int.parse(
                                                          filteredData[index]['id']))));
                                        },
                                        backgroundColor: const Color(
                                            0xFF0392CF),
                                        foregroundColor: Colors.white,
                                        icon: Icons.remove_red_eye,
                                        label: 'عرض الزبون',
                                      ),

                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        flex: 1,
                                        onPressed: (contextD) async {
                                          getClientByID(int.parse(
                                              filteredData[index]['id']));
                                          _modalUpdateClient(contextD,
                                              int.parse(filteredData[index]['id']));
                                        },
                                        backgroundColor: const Color(0xFF7BC043),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'تعديل',
                                      ),
                                      SlidableAction(
                                        flex: 1,
                                        onPressed: (contextD) async {
                                          deleteClient(int.parse(
                                              filteredData[index]['id']));
                                        },
                                        backgroundColor: const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'مسح',
                                      ),
                                    ],
                                  ),
                                  child:
                                  GFCard(
                                    boxFit: BoxFit.cover,
                                    titlePosition: GFPosition.start,
                                    image: Image.asset(
                                      'assets/images/gold.png',
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                    showImage: true,
                                    title: GFListTile(
                                      avatar: GFAvatar(
                                        backgroundImage: AssetImage('assets/images/icone_cheque.jpg'),
                                      ),
                                      titleText: 'Title',
                                      subTitleText: 'Sub Title',
                                    ),
                                    content: Text("Some quick example text to build on the card"),
                                    buttonBar: GFButtonBar(
                                      children: <Widget>[
                                        GFAvatar(
                                          child: Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                          ),
                                        ),
                                        GFAvatar(
                                          backgroundColor: GFColors.DARK,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          ),
                                        ),
                                        GFAvatar(
                                          backgroundColor: GFColors.DANGER,
                                          child: Icon(
                                            Icons.help,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                        );
                    }

                  }
              ) )

            ]
        )
    );

  }
  void _modalAddClient(BuildContext context) =>   showModalBottomSheet<void>(

    context: context,
    builder: (BuildContext context) {
      return Form(
          key: formState,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 600,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('إضافة زبون جديد',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الإسم العائلي !';
                      }
                      return null;
                    },
                    controller: nomC,
                    decoration: InputDecoration(
                        label: const Text('الإسم العائلي'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الإسم الشخصي !';
                      }
                      return null;
                    },
                    controller: prenomC,
                    decoration: InputDecoration(
                        label: const Text('الإسم الشخصي'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: villeC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال المدينة !';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: const Text('المدينة'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف !';
                      }
                      return null;
                    },
                    controller: telC,
                    decoration: InputDecoration(
                        label: const Text('رقم الهاتف'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )),),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => {
                          if (formState.currentState!.validate()) {
                            _addClient()

                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'إضافة',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ), // <-- Text
                            Icon(
                              // <-- Icon
                              Icons.add,
                              color: Colors.orange,
                              size: 24.0,
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(width: 5,),
                      OutlinedButton(

                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'إلغاء',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ), // <-- Text
                            Icon(
                              // <-- Icon
                              Icons.close,
                              color: Colors.orange,
                              size: 24.0,
                            ),

                          ],
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          )
      );

    },
  );
  void _modalUpdateClient(BuildContext context,int id) =>   showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Form(
          key: formState,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 600,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(' تعديل الزبون ${nomC.text} ${prenomC.text}',
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الإسم العائلي !';
                      }
                      return null;
                    },
                    controller: nomC,
                    decoration: InputDecoration(
                        label: const Text('الإسم العائلي'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الإسم الشخصي !';
                      }
                      return null;
                    },
                    controller: prenomC,
                    decoration: InputDecoration(
                        label: const Text('الإسم الشخصي'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: villeC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال المدينة !';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: const Text('المدينة'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف !';
                      }
                      return null;
                    },
                    controller: telC,
                    decoration: InputDecoration(
                        label: const Text('رقم الهاتف'),
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintStyle:  const TextStyle(fontSize: 14,color: Colors.grey),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )),),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => {
                          if (formState.currentState!.validate()) {

                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'تعديل',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ), // <-- Text
                            Icon(
                              Icons.edit,
                              color: Colors.orange,
                              size: 24.0,
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(width: 5,),
                      OutlinedButton(

                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'إلغاء',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ), // <-- Text
                            Icon(
                              // <-- Icon
                              Icons.close,
                              color: Colors.orange,
                              size: 24.0,
                            ),

                          ],
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          )
      );

    },
  );

  void reloadData() {
    setState(() {
      getClients();
      Navigator.pop(context);
    });
  }
}
class MyTextSample{

  static TextStyle? display4(BuildContext context){
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context){
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context){
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context){
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context){
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context){
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context){
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 18,
    );
  }

  static TextStyle? subhead(BuildContext context){
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context){
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context){
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context){
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context){
    return Theme.of(context).textTheme.labelLarge!.copyWith(
        letterSpacing: 1
    );
  }

  static TextStyle? subtitle(BuildContext context){
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context){
    return Theme.of(context).textTheme.labelSmall;
  }

}



