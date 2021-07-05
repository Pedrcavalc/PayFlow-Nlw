import 'package:flutter/material.dart';
import 'package:payflow/modules/barcode_scanner/bar_code_scanner_controller.dart';
import 'bar_code_scanner_status.dart';
import 'package:payflow/shared/theme/app_colors.dart';
import 'package:payflow/shared/theme/app_text_styles.dart';
import 'package:payflow/shared/theme/widgets/bottom_sheet/botton_sheet_widget.dart';
import 'package:payflow/shared/theme/widgets/set_label_buttons/set_label_buttons.dart';

class BarCodeScannerPage extends StatefulWidget {
  const BarCodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarCodeScannerPageState createState() => _BarCodeScannerPageState();
}

class _BarCodeScannerPageState extends State<BarCodeScannerPage> {
  final controller = BarcodeScannerController();
  @override
  void initState() {
    controller.getAvailableCameras();
    controller.statusNotifier.addListener(() {
      if (controller.status.hasBarcode) {
        Navigator.pushReplacementNamed(context, "/insert_boleto_page");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Stack(
        children: [
          ValueListenableBuilder<BarcodeScannerStatus>(
              valueListenable: controller.statusNotifier,
              builder: (_, status, __) {
                if (status.showCamera) {
                  return Container(
                      child: controller.cameraController!.buildPreview());
                } else {
                  return Container();
                }
              }),
          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.black,
                  title: Text(
                    "Escaneie o código do boleto",
                    style: TextStyles.buttonBackground,
                  ),
                  leading: BackButton(
                    color: AppColors.background,
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                        child: Container(
                      color: Colors.black.withOpacity(0.6),
                    )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.transparent,
                        )),
                    Expanded(
                        child: Container(
                      color: Colors.black.withOpacity(0.6),
                    )),
                  ],
                ),
                bottomNavigationBar: SetLabelButton(
                    primaryLabel: "Inserir código do boleto",
                    primaryOnPressed: () {
                      Navigator.pushReplacementNamed(context, "/insert_boleto");
                    },
                    secondaryLabel: "Adicionar da galeria",
                    secondaryOnPressed: () {})),
          ),
          ValueListenableBuilder<BarcodeScannerStatus>(
              valueListenable: controller.statusNotifier,
              builder: (_, status, __) {
                if (status.hasError) {
                  return BottomSheetWidget(
                    title: "Não foi possível identificar um código de barras.",
                    subtitle:
                        "Tente escanear novamente ou digite o código do seu boleto.",
                    primaryLabel: "Escanear novamente",
                    primaryOnPressed: () {
                      controller.scanWithCamera();
                    },
                    secondaryLabel: "Digitar codigo",
                    secondaryOnPressed: () {
                      Navigator.pushReplacementNamed(context, "/insert_boleto");
                    },
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}
