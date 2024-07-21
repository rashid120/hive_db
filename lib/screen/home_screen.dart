
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _hiveData = false;

  late String name;
  late String number;

  @override
  void initState() {
    super.initState();

    checkData();
  }

  void checkData() async {

    var box = await Hive.openBox('userDetail');
    bool c =  box.isNotEmpty;
    setState(() {
      _hiveData = c;
    });
    name = box.get('name');
    number = box.get('number');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: const Text('Hive database'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Colors.blueGrey,
              child: SizedBox(height: 200, width: 200,),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {

        showBottomSheet();

      }, child: const Icon(Icons.add),),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(accountName: Text(_hiveData ? name : 'Create account' ), accountEmail: Text(_hiveData ? number : 'Create account'), currentAccountPicture: const CircleAvatar(radius: 30,),),
          ],
        ),
      ),
    );
  }

  void showBottomSheet() async{
     showModalBottomSheet(isScrollControlled: true,context: context, builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text("Create new account", style: TextStyle(fontSize: 18),),
                const SizedBox(height: 15,),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter your name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                      labelText: "Enter your number",
                      prefixIcon: const Icon(Icons.phone_android),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Create password",
                      prefixIcon: const Icon(Icons.password),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),)
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(onPressed: () async {

                    var box = await Hive.openBox('userDetail');

                    if(nameController.text.isEmpty || numberController.text.isEmpty || passwordController.text.isEmpty){

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required"), backgroundColor: Colors.redAccent,));
                      Navigator.of(context).pop();

                    }else{

                      box.put('name', nameController.text);
                      box.put('number', numberController.text);
                      box.put('password', passwordController.text);

                      await Future.delayed(const Duration(milliseconds: 200));
                      Navigator.of(context).pop();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successful"), backgroundColor: Colors.blueGrey,));

                      nameController.clear();
                      numberController.clear();
                      passwordController.clear();
                    }
                  }, splashColor: Colors.greenAccent, color: Colors.blueGrey, child: const Text("Submit", style: TextStyle(color: Colors.white),),),
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }

}
