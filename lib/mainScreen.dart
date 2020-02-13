import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sms/sms.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<SendLog> _sendLog = [];
  @override
  void initState() {
    OneSignal.shared.setNotificationReceivedHandler(_notifHandler);
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);
    SimCardsProvider().getSimCards().then((_) {
      if (_ != null) _simCard = _.first;
      setState(() {});
    });
    super.initState();
  }

  void _notifHandler(OSNotification osNotif) async {
    await _sendMessage(to: osNotif.payload.additionalData["nohp"], message: osNotif.payload.additionalData["message"]);
    setState(() {});
  }

  Future<SendLog> _sendMessage({String to, String message}) async {
    try {
      SmsMessage smsMessage = SmsMessage(to, message);
      smsMessage.onStateChanged.listen((_) {
        if (_ == SmsMessageState.Sent) {
          _sendLog.add(SendLog(true, message, to));
          setState(() {});
        } else if (_ == SmsMessageState.Fail) {
          _sendLog.add(SendLog(false, message, to));
          setState(() {});
        }
      });

      SmsSender smsSender = SmsSender();
      smsSender.sendSms(smsMessage, simCard: _simCard);
    } catch (e) {}
    return SendLog(false, message, to);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NSMS Flutter"),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              _simCard == null ? "Pilih SIM" : "SIM " + _simCard.slot.toString(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _selectSimCard,
          )
        ],
        bottom: PreferredSize(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(.1),
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Text(
              "Aplikasi otomatis aktif dan menunggu perintah notif.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.yellow),
            ),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 30),
        ),
      ),
      body: ListView.builder(
        itemCount: _sendLog.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_sendLog[index].to.toString()),
            subtitle: Text(_sendLog[index].message.toString(), maxLines: 3),
            leading: CircleAvatar(
              child: Icon(_sendLog[index].status ?? false ? Icons.done : Icons.close),
            ),
          );
        },
      ),
    );
  }

  SimCard _simCard;
  void _selectSimCard() async {
    SimCardsProvider provider = new SimCardsProvider();
    var resp = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pilih Simcard"),
            actions: <Widget>[
              FlatButton(
                child: Text("Tutup"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: FutureBuilder<List<SimCard>>(
              future: provider.getSimCards(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.only(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("SIM ${snapshot.data[index].slot}"),
                          onTap: () {
                            Navigator.pop(context, snapshot.data[index]);
                          },
                        );
                      });
                } else {
                  return Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        });
    if (resp != null) _simCard = resp;
    setState(() {});
  }
}

class SendLog {
  final bool status;
  final String message;
  final String to;

  SendLog(this.status, this.message, this.to);
}
