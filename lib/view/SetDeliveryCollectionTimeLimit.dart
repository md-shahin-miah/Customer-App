import 'package:blue/model/del_col_time.dart';
import 'package:flutter/material.dart';

class SetDeliveryCollectionTimeLimit extends StatefulWidget {
  String dayName;
  String index;

  SetDeliveryCollectionTimeLimit(this.dayName, this.index);

  @override
  _SetDeliveryCollectionTimeLimitState createState() =>
      _SetDeliveryCollectionTimeLimitState();
}

class _SetDeliveryCollectionTimeLimitState
    extends State<SetDeliveryCollectionTimeLimit> {
  TextEditingController deliveryTimeController;
  TextEditingController collectionTimeController;

  String deliveryTime = "";
  String collectionTime = "";
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState

    // deliveryTimeController = TextEditingController();
    // collectionTimeController = TextEditingController();

    DelColTimeModel.getDelColTimeLimit(widget.index.toString()).then((value) {
      setState(() {
        isLoading = false;
        deliveryTime = value['dt_del_time'];
        collectionTime = value['dt_col_time'];

        deliveryTimeController = TextEditingController(text: deliveryTime);
        collectionTimeController = TextEditingController(text: collectionTime);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayName),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: deliveryTimeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Time in minute',
                        labelText: 'Delivery time limit',
                        suffixText: 'min',
                        suffixStyle: const TextStyle(color: Colors.green)),
                    onChanged: (val) {
                      setState(() {
                        deliveryTimeController.text = val;
                        deliveryTimeController.selection =
                            TextSelection.collapsed(
                                offset: deliveryTimeController.text.length);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: collectionTimeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Time in minute',
                        labelText: 'Collection time limit',
                        suffixText: 'min',
                        suffixStyle: const TextStyle(color: Colors.green)),
                    onChanged: (val) {
                      setState(() {
                        collectionTimeController.text = val;
                        collectionTimeController.selection =
                            TextSelection.collapsed(
                                offset: collectionTimeController.text.length);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        DelColTimeModel.updateDelColLimit(
                                widget.index,
                                widget.dayName,
                                deliveryTimeController.text,
                                collectionTimeController.text)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
