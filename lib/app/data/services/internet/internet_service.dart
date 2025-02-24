import 'dart:async';

import 'package:canteen_app/app/data/services/base_service.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckInternetService extends BaseService {
  static CheckInternetService get instance => Get.find<CheckInternetService>();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  final RxList<ConnectivityResult> _connectionStatus =
      <ConnectivityResult>[ConnectivityResult.none].obs;
  final RxBool _isConnected = false.obs;
  bool _isNoInternetDialogShowing = false;

  RxList<ConnectivityResult> get connectionStatus => _connectionStatus;
  RxBool get isConnected => _isConnected;

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
      _subscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      HLoggerHelper.error('Couldn\'t check connectivity status: $e');
      return;
    }

    return _updateConnectionStatus(result);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
  }

  void _showNoInternetScreen() {
    // Only show dialog if it's not already showing
    if (!_isNoInternetDialogShowing) {
      HLoggerHelper.info("dialog shown");
      _isNoInternetDialogShowing = true;
      Get.dialog(
        PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.signal_wifi_off,
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_isNoInternetDialogShowing) {
                        Get.back();
                        _isNoInternetDialogShowing = false;
                      }
                      await initConnectivity();
                      if (!_isConnected.value) {
                        _showNoInternetScreen();
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus.value = result;

    // Add a small delay to ensure dialog logic runs
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_connectionStatus.contains(ConnectivityResult.none)) {
        _isConnected.value = false;
        HLoggerHelper.info('No internet showing internet screen');
        _showNoInternetScreen();
      } else {
        _isConnected.value = true;
        if (_isNoInternetDialogShowing) {
          Get.back();
          _isNoInternetDialogShowing = false;
        }
      }
    });

    // Handle different connection types
    // if (_connectionStatus.contains(ConnectivityResult.mobile)) {
    //   print('Mobile network connected');
    // } else if (_connectionStatus.contains(ConnectivityResult.wifi)) {
    //   print('WiFi connected');
    // } else if (_connectionStatus.contains(ConnectivityResult.ethernet)) {
    //   print('Ethernet connected');
    // } else if (_connectionStatus.contains(ConnectivityResult.vpn)) {
    //   print('VPN connected');
    // } else if (_connectionStatus.contains(ConnectivityResult.bluetooth)) {
    //   print('Bluetooth connected');
    // } else if (_connectionStatus.contains(ConnectivityResult.other)) {
    //   print('Other network type connected');
    // } else if (_connectionStatus.contains(ConnectivityResult.none)) {
    //   print('No network connection');
    // }
  }
}
