import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class GlobalProvider extends ChangeNotifier {
  GlobalProvider() {
    initPlatformState();
  }

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> devices = [];

  bool connected = false;

  BluetoothDevice device;
  BluetoothDevice bluetoothDevice;

  bool _isBlueOn = false;

  bool isBluetoothOn = true;
  bool  isPrinterConnected = false;

  bool get bluetoothStatus => _isBlueOn;

  setBluetoothDevice(BluetoothDevice device){
    bluetoothDevice=device;
  }

  getBluetoothDevice()
  {
    return bluetoothDevice;
  }
  setBluetoothOnTrue() {
    print('setBluetoothOnTrue');
    isBluetoothOn = true;
    notifyListeners();
  }

  setBluetoothOnFalse() {
    print('setBluetoothOnFalse');

    isBluetoothOn = false;
    notifyListeners();
  }

  setPrinterConnectTrue() {
    print('setPrinterConnectTrue');

    isPrinterConnected = true;
    notifyListeners();
  }

  setPrinterConnectFalse() {
    print('setPrinterConnectFalse');
    isPrinterConnected = false;
    notifyListeners();
  }

  bool get getPrinterConnectionStatus => isPrinterConnected;

  bool get getBluetoothOn => isBluetoothOn;

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    _isBlueOn = await bluetooth.isOn;
    List<BluetoothDevice> devices = [];

   try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {

    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected = true;
          print('connected---------------------------$connected');

          // PrinterHome.connected=connected;
          notifyListeners();
          break;

        case BlueThermalPrinter.DISCONNECTED:
          print('disconnected in pro---------------------------$connected');
          connected = false;
          setPrinterConnectFalse();
          // PrinterHome.connected=connected;
          notifyListeners();
          break;



        default:
          print(state);
          break;
      }
    });

    if (isConnected) {

      connected = true;
      devices = devices;
      device = devices[0];

    }

    notifyListeners();
  }





}
