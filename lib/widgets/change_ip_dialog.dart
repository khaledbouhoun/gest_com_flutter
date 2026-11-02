import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';

class ChangeIPDialog extends StatefulWidget {
  const ChangeIPDialog({super.key});
  @override
  State<StatefulWidget> createState() => ChangeIPDialogDialogPage();

  static void showChangeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ChangeIPDialog();
        });
  }
}

class ChangeIPDialogDialogPage extends State<ChangeIPDialog> {
  TextEditingController ip = TextEditingController();
  TextEditingController port = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ip.dispose();
    port.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    ip.text = authProvider.ipaddress!;
    port.text = authProvider.port!;
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      content: SingleChildScrollView(
        child: SizedBox(
          width: width * 0.75,
          child: Column(
            children: [
              Center(
                child: Text(
                  'Changer Adresse IP et port',
                  style: TextStyle(
                      fontSize: width * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adresse IP',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromRGBO(4, 103, 138, 1.0)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      controller: ip,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Port',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromRGBO(4, 103, 138, 1.0)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      controller: port,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.03,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (ip.text != '' || port.text != '') {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    authProvider.ipaddress = ip.text.trim();
                    authProvider.port = port.text;
                    prefs.setString('ipaddress', ip.text.trim());
                    prefs.setString('port', port.text);
                  }
                  Toast(
                      context: context,
                      title:
                          'Adresse ip: ${authProvider.ipaddress}\nPort: ${authProvider.port}',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.info,
                      duration: 4);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).secondaryHeaderColor)),
                child: const Text(
                  'Confirmer',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
