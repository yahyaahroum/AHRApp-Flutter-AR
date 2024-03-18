import 'package:flutter_gen_l10n_example/imagestransaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'Services/TransactionsService.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';
import 'package:intl/intl.dart';


class DetailClient extends StatefulWidget {
  final int idClient;
  const DetailClient({Key? key, required this.idClient}) : super(key: key);

  @override
  _DetailClientState createState() => _DetailClientState(this.idClient);
}

class _DetailClientState extends State<DetailClient> {

  int _idClient;
  _DetailClientState(this._idClient);
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String searchString="";
  List<String> buttonListType=["أخد","أعطى"];
  List<String> buttonListGenre=["ذهب","نقود"];
  TextEditingController dateT=TextEditingController();
  TextEditingController valeurT=TextEditingController();
  TextEditingController imageT=TextEditingController();
  String typeT='أخد';
  String genreT='ذهب';
  String libelleValeur='';
  int selectedGenre=0;
  int selectedType=0;
  getTransactions() async{
    return await TransactionsServices.getTransactions(_idClient);
  }
  getTransactionByID(int id){
    TransactionsServices.FindTransactionById(id).then((c) {

      dateT.text = DateFormat('yyyy-MM-dd').format(c.date_transaction);
      valeurT.text = c.valeur.toString();


    });
  }
  addTransaction() async{
    await TransactionsServices.addTransaction(dateT.text, typeT, genreT, valeurT.text.replaceAll(",", "."), 'imageT',_idClient);
    reloadData();
    clearValues();
  }
  void updateTransaction(int id) async {
    await TransactionsServices.updateTransaction(id,dateT.text, typeT, genreT, valeurT.text );
    clearValues();
    reloadData();
  }
  void deleteTransaction(int id) {

    PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: "أهلا",
      message: "هل أنت متأكد أنك تريد حذف هذه المعاملة ؟",
      confirmButtonText: "تأكيد",
      cancelButtonText: "إلغاء",
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () async {
        await TransactionsServices.deleteTransaction(id);
        reloadData();
      },
      panaraDialogType: PanaraDialogType.warning,
    );
  }
  clearValues() {
    dateT.clear();
    valeurT.clear();
    typeT='أخد';
    genreT='ذهب';
  }
  @override
  void initState(){
    getTransactions();
    super.initState();
  }
  onTapFunction() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2015),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    dateT.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //clearValues();
          _modalAddTransaction(context);
        },

        tooltip: 'إضافة معاملة',
        child:  const Icon(Icons.add),
      ), // This
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('معاملة'),
              centerTitle: true,
              iconTheme: const IconThemeData(
                  color:Colors.orange
              ),
              backgroundColor: Colors.grey[200],
              titleTextStyle: const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 17),
              bottom:
              const TabBar(
                tabs:[
                  Tab(
                    child: Text('الكل'),
                  ),
                  Tab(
                    child: Text('أخد'),
                  ),
                  Tab(
                    child: Text('أعطى'),

                  ),
                ],

              ),
            ),
            body:
            TabBarView(
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child:
                          TextField(
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
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
                            future: getTransactions(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                child: CircularProgressIndicator(color: Colors.orange));

                              } else {
                                List filteredData = snapshot.data.where((item) =>
                                item['date_transaction'].toLowerCase().contains(searchString) ||
                                    item['type_transaction'].toLowerCase().contains(searchString) ||
                                    item['montant'].toLowerCase().contains(searchString) ||
                                    item['poid'].toLowerCase().contains(searchString))
                                    .toList();


                                // Render student lists
                                return
                                  ListView.builder(
                                    itemCount: filteredData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child :
                                          SafeArea(
                                          top: true,
                                          bottom: false,
                                          child:
                                          Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Slidable(
                                      key: const ValueKey(0),
                                      startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                      SlidableAction(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      flex: 1,
                                      onPressed:(contextD) async {
                                      Navigator.push(context, MaterialPageRoute(
                                      builder: (context)=>
                                      ImagesTransaction(idTransaction: int.parse(filteredData[index]['id']),)));

                                      },
                                      backgroundColor: const Color(0xFF0392CF),
                                      foregroundColor: Colors.white,
                                      icon: Icons.remove_red_eye,
                                      label: 'عرض الصور',
                                      ),

                                      ],
                                      ),
                                      endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                      SlidableAction(
                                          // An action can be bigger than the others.
                                          flex: 1,
                                          onPressed: (contextD) async {
                                            getTransactionByID(int.parse(
                                                filteredData[index]['id']));
                                            _modalUpdateClient(contextD,
                                                int.parse(filteredData[index]['id']),
                                              filteredData[index]['type_transaction']=="أخد"? 0 : 1,
                                                filteredData[index]['genre_transaction']=="ذهب"? 0 : 1,

                                            );
                                          },
                                          backgroundColor: const Color(0xFF7BC043),
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'تعديل',
                                        ),
                                      SlidableAction(
                                          flex: 1,
                                          onPressed: (contextD) async {
                                            deleteTransaction(int.parse(
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
                                      Card (
                                      shape: RoundedRectangleBorder(
                                      side:  BorderSide(color:filteredData[index]['type_transaction'] =="أعطى" ? Colors.green : Colors.red,width: 3),
                                      borderRadius: const BorderRadius.all(Radius.circular(15))
                                      ),
                                      shadowColor: Colors.green[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                      child:
                                      ListTile(
                                      leading: CircleAvatar(
                                      backgroundImage: AssetImage(filteredData[index]['genre_transaction']=="نقود" ? 'assets/images/money.png' : 'assets/images/gold.png', ),

                                      ),
                                      title:
                                      Row(
                                        children: [
                                          Text(filteredData[index]['type_transaction'] +
                                              ' '+ filteredData[index]['genre_transaction'],
                                              style: const TextStyle(fontSize: 20),textAlign: TextAlign.end),
                                          const SizedBox(width: 80,),
                                          Text(filteredData[index]['date_transaction'] ,
                                              style: const TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      subtitle:

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(filteredData[index]['valeur'],
                                            style: const TextStyle(fontSize: 25,color: Colors.black87),),
                                          const SizedBox(width: 5,),
                                          Text(filteredData[index]['genre_transaction']=="نقود" ? 'درهم' : 'غرام',
                                            style: const TextStyle(fontSize: 25,color: Colors.black87),),
                                        ],
                                      ),
                                      ),
                                      ),
                                      ),
                                      ))));
                                    },
                                  );
                              }

                            }
                        ) )

                      ]
                  ),
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
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),

                        ),
                        Expanded(child:

                        FutureBuilder(
                            future: getTransactions(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator(color: Colors.orange));

                              } else {
                                List filteredData = snapshot.data.where((item) =>
                                    item['type_transaction'].toLowerCase().contains("أخد")&&(item['date_transaction'].toLowerCase().contains(searchString) ||
                                    item['montant'].toLowerCase().contains(searchString) ||
                                    item['poid'].toLowerCase().contains(searchString)))
                                    .toList();


                                // Render student lists
                                return
                                  ListView.builder(
                                    itemCount: filteredData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child :
                                            SafeArea(
                                                top: true,
                                                bottom: false,
                                                child:
                                                Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                                    child: Slidable(
                                                      // Specify a key if the Slidable is dismissible.
                                                      key: const ValueKey(0),
                                                      startActionPane: ActionPane(
                                                        motion: const ScrollMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                            flex: 1,
                                                            onPressed:(contextD) async {
                                                              Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context)=>
                                                                      ImagesTransaction(idTransaction: int.parse(filteredData[index]['id']),)));

                                                            },
                                                            backgroundColor: const Color(0xFF0392CF),
                                                            foregroundColor: Colors.white,
                                                            icon: Icons.remove_red_eye,
                                                            label: 'عرض الصور',
                                                          ),

                                                        ],
                                                      ),
                                                      endActionPane: ActionPane(
                                                        motion: const ScrollMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            // An action can be bigger than the others.
                                                            flex: 1,
                                                            onPressed: (contextD) async {
                                                              getTransactionByID(int.parse(
                                                                  filteredData[index]['id']));
                                                              _modalUpdateClient(contextD,
                                                                int.parse(filteredData[index]['id']),
                                                                filteredData[index]['type_transaction']=="أخد"? 0 : 1,
                                                                filteredData[index]['genre_transaction']=="ذهب"? 0 : 1,

                                                              );
                                                            },
                                                            backgroundColor: const Color(0xFF7BC043),
                                                            foregroundColor: Colors.white,
                                                            icon: Icons.edit,
                                                            label: 'تعديل',
                                                          ),
                                                          SlidableAction(
                                                            flex: 1,
                                                            onPressed: (contextD) async {
                                                              deleteTransaction(int.parse(
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
                                                      Card (
                                                        shape: RoundedRectangleBorder(
                                                            side:  BorderSide(color:filteredData[index]['type_transaction'] =="أعطى" ? Colors.green : Colors.red,width: 3),
                                                            borderRadius: const BorderRadius.all(Radius.circular(15))
                                                        ),
                                                        shadowColor: Colors.green[100],
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child:
                                                          ListTile(
                                                            leading: CircleAvatar(
                                                              backgroundImage: AssetImage(filteredData[index]['genre_transaction']=="نقود" ? 'assets/images/money.png' : 'assets/images/gold.png', ),

                                                            ),
                                                            title:
                                                            Row(
                                                              children: [
                                                                Text(filteredData[index]['type_transaction'] +
                                                                    ' '+ filteredData[index]['genre_transaction'],
                                                                    style: const TextStyle(fontSize: 20),textAlign: TextAlign.end),
                                                                const SizedBox(width: 80,),
                                                                Text(filteredData[index]['date_transaction'] ,
                                                                    style: const TextStyle(fontSize: 20)),
                                                              ],
                                                            ),
                                                            subtitle:

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(filteredData[index]['valeur'],
                                                                  style: const TextStyle(fontSize: 25,color: Colors.black87),),
                                                                const SizedBox(width: 5,),
                                                                Text(filteredData[index]['genre_transaction']=="نقود" ? 'درهم' : 'غرام',
                                                                  style: const TextStyle(fontSize: 25,color: Colors.black87),),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))));
                                    },
                                  );
                              }

                            }
                        ) )

                      ]
                  ),
                  Container(
                      child: Column(
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
                                  labelText: 'Search',
                                  suffixIcon: Icon(Icons.search),
                                ),
                              ),

                            ),
                            Expanded(child:

                            FutureBuilder(
                                future: getTransactions(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator(color: Colors.orange));

                                  } else {
                                    List filteredData = snapshot.data.where((item) =>
                                        item['type_transaction'].toLowerCase().contains("أعطى") &&(
                                            item['date_transaction'].toLowerCase().contains(searchString) ||
                                                item['montant'].toLowerCase().contains(searchString) ||
                                                item['poid'].toLowerCase().contains(searchString)
                                        )
                                )
                                        .toList();


                                    // Render student lists
                                    return
                                      ListView.builder(
                                        itemCount: filteredData.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child :
                                                SafeArea(
                                                    top: true,
                                                    bottom: false,
                                                    child:
                                                    Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                                        child: Slidable(
                                                          // Specify a key if the Slidable is dismissible.
                                                          key: const ValueKey(0),
                                                          startActionPane: ActionPane(
                                                            motion: const ScrollMotion(),
                                                            children: [
                                                              SlidableAction(
                                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                flex: 1,
                                                                onPressed:(contextD) async {
                                                                  Navigator.push(context, MaterialPageRoute(
                                                                      builder: (context)=>
                                                                          ImagesTransaction(idTransaction: int.parse(filteredData[index]['id']),)));

                                                                },
                                                                backgroundColor: const Color(0xFF0392CF),
                                                                foregroundColor: Colors.white,
                                                                icon: Icons.remove_red_eye,
                                                                label: 'عرض الصور',
                                                              ),

                                                            ],
                                                          ),
                                                          endActionPane: ActionPane(
                                                            motion: const ScrollMotion(),
                                                            children: [
                                                              SlidableAction(
                                                                // An action can be bigger than the others.
                                                                flex: 1,
                                                                onPressed: (contextD) async {
                                                                  getTransactionByID(int.parse(
                                                                      filteredData[index]['id']));
                                                                  _modalUpdateClient(contextD,
                                                                    int.parse(filteredData[index]['id']),
                                                                    filteredData[index]['type_transaction']=="أخد"? 0 : 1,
                                                                    filteredData[index]['genre_transaction']=="ذهب"? 0 : 1,

                                                                  );
                                                                },
                                                                backgroundColor: const Color(0xFF7BC043),
                                                                foregroundColor: Colors.white,
                                                                icon: Icons.edit,
                                                                label: 'تعديل',
                                                              ),
                                                              SlidableAction(
                                                                flex: 1,
                                                                onPressed: (contextD) async {
                                                                  deleteTransaction(int.parse(
                                                                      filteredData[index]['id']));
                                                                },
                                                                backgroundColor: Color(0xFFFE4A49),
                                                                foregroundColor: Colors.white,
                                                                icon: Icons.delete,
                                                                label: 'مسح',
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                          Card (
                                                            shape: RoundedRectangleBorder(
                                                                side:  BorderSide(color:filteredData[index]['type_transaction'] =="أعطى" ? Colors.green : Colors.red,width: 3),
                                                                borderRadius: const BorderRadius.all(Radius.circular(15))
                                                            ),
                                                            shadowColor: Colors.green[100],
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(10),
                                                              child:
                                                              ListTile(
                                                                leading: CircleAvatar(
                                                                  backgroundImage: AssetImage(filteredData[index]['genre_transaction']=="نقود" ? 'assets/images/money.png' : 'assets/images/gold.png', ),

                                                                ),
                                                                title:
                                                                Row(
                                                                  children: [
                                                                    Text(filteredData[index]['type_transaction'] +
                                                                        ' '+ filteredData[index]['genre_transaction'],
                                                                        style: const TextStyle(fontSize: 20),textAlign: TextAlign.end),
                                                                    const SizedBox(width: 80,),
                                                                    Text(filteredData[index]['date_transaction'] ,
                                                                        style: const TextStyle(fontSize: 20)),
                                                                  ],
                                                                ),
                                                                subtitle:

                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(filteredData[index]['valeur'],
                                                                      style: const TextStyle(fontSize: 25,color: Colors.black87),),
                                                                    const SizedBox(width: 5,),
                                                                    Text(filteredData[index]['genre_transaction']=="نقود" ? 'درهم' : 'غرام',
                                                                      style: const TextStyle(fontSize: 25,color: Colors.black87),),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ))));
                                        },
                                      );
                                  }

                                }
                            ) )

                          ]
                      )
                  ),

                ]
            ),
          ),
        ),
      );


  }
  void _modalAddTransaction(BuildContext context) =>   showModalBottomSheet<void>(

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
                  const Text('إضافة معاملة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  const SizedBox(height: 10,),

                  TextFormField(
                   textAlign: TextAlign.start,
                    keyboardType: TextInputType.none,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'المرجوا إدخال تاريخ العملية !';
                      }
                      return null;
                    },
                    controller: dateT,
                    onTap: () {
                      onTapFunction();
                    },

                    decoration: InputDecoration(

                        label: const Text('تاريخ المعاملة'),
                        prefixIcon: const Icon(Icons.calendar_today),
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
                        contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  const BorderSide(color: Colors.grey)
                        )
                    ),
                  ),
                 const SizedBox(height: 10,),
                  Container(

                    padding: const EdgeInsets.all(2),
                    //width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomRadioButton(
                          buttonLables: buttonListType,
                          buttonValues: buttonListType,
                          radioButtonValue: (value,index) {
                            typeT=value;
                          },

                          horizontal: true,
                          enableShape: true,
                          buttonSpace: 5,
                          fontSize: 18,
                          buttonColor: Colors.white,
                          selectedColor: Colors.cyan,
                          buttonWidth: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(

                    padding: const EdgeInsets.all(2),
                    //width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomRadioButton(
                          buttonLables: buttonListGenre,
                          buttonValues: buttonListGenre,
                          radioButtonValue: (value,index){
                              genreT=value;
                          },
                          horizontal: true,
                          enableShape: true,
                          buttonSpace: 15,
                          fontSize: 18,
                          buttonColor: Colors.white,
                          selectedColor: Colors.orangeAccent,
                          buttonWidth: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'المرجوا إدخال قيمة المعاملة !';
                      }
                      return null;
                    },
                    controller: valeurT,
                    decoration: InputDecoration(
                        label: const Text('القيمة ' ),
                        alignLabelWithHint: true,
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

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
                            addTransaction()

                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ajouter',
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
                              'Annuler',
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
  void _modalUpdateClient(BuildContext context,int id,int selectedType,int selectedGenre) =>   showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return
        Form(
            key: formState,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 600,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('تعديل معاملة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    const SizedBox(height: 10,),

                    TextFormField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.none,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'المرجوا إدخال تاريخ العملية !';
                        }
                        return null;
                      },
                      controller: dateT,
                      onTap: () {
                        onTapFunction();
                      },

                      decoration: InputDecoration(

                          label: const Text('تاريخ المعاملة'),
                          suffixIcon: const Icon(Icons.calendar_today),
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
                          contentPadding:  const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:  const BorderSide(color: Colors.grey)
                          )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(

                      padding: const EdgeInsets.all(2),
                      //width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomRadioButton(
                            buttonLables: buttonListType,
                            buttonValues: buttonListType,
                            radioButtonValue: (value,index) {
                              typeT=value;
                            },

                            horizontal: true,
                            enableShape: true,
                            buttonSpace: 5,
                            fontSize: 18,
                            initialSelection: selectedType,
                            buttonColor: Colors.white,
                            selectedColor: Colors.cyan,
                            buttonWidth: 150,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(

                      padding: EdgeInsets.all(2),
                      //width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomRadioButton(
                            buttonLables: buttonListGenre,
                            buttonValues: buttonListGenre,
                            radioButtonValue: (value,index){
                              genreT=value;
                            },
                            horizontal: true,
                            enableShape: true,
                            buttonSpace: 15,
                            fontSize: 18,
                            initialSelection: selectedGenre,
                            buttonColor: Colors.white,
                            selectedColor: Colors.cyan,
                            buttonWidth: 150,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'المرجوا إدخال قيمة المعاملة !';
                        }
                        return null;
                      },
                      controller: valeurT,
                      decoration: InputDecoration(
                          label: const Text('القيمة ' ),
                          alignLabelWithHint: true,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

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
                              updateTransaction(id),

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
                                // <-- Icon
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
      getTransactions();
      Navigator.pop(context);
    });
  }
}
