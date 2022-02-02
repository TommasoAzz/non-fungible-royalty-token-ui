import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../constants/app_colors.dart';

class RentTokenView extends StatefulWidget {
  final double rentalPricePerSecond;
  final String collectionAddress;
  final int tokenId;

  const RentTokenView({
    Key? key,
    required this.rentalPricePerSecond,
    required this.collectionAddress,
    required this.tokenId,
  }) : super(key: key);

  @override
  State<RentTokenView> createState() => _RentTokenViewState();
}

class _RentTokenViewState extends State<RentTokenView> {
  final vm = locator<MarketplaceVM>();
  int selectedEndRentalDateMillis = 0;

  bool rented = false;
  bool renting = false;

  Future<void> _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(initialDate.year + 5),
    );

    if (newDate == null) return;

    setState(() {
      selectedEndRentalDateMillis = newDate.millisecondsSinceEpoch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            primary: primaryColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _pickDate(context),
          child: selectedEndRentalDateMillis == 0
              ? const Text('Select date')
              : Text(
                  'Selected date: ${DateFormat('dd/MM/yy').format(DateTime.fromMillisecondsSinceEpoch(selectedEndRentalDateMillis))}',
                ),
        ),
        selectedEndRentalDateMillis == 0
            ? const SelectableText("")
            : SelectableText(
                "The cost for this rent is: ${(selectedEndRentalDateMillis - DateTime.now().millisecondsSinceEpoch) * 1000 * widget.rentalPricePerSecond} ETH.",
              ),
        ElevatedButton(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (rented)
                const Text(
                  "Submitted",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              if (rented) const Icon(Icons.check_box, size: 16),
              if (!rented)
                const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              if (renting) const SizedBox(width: 10),
              if (renting)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            primary: primaryColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _rent,
        ),
      ],
    );
  }

  Future<void> _rent() async {
    setState(() {
      renting = true;
    });

    try {
      await vm.rentAsset(
        widget.collectionAddress,
        widget.tokenId,
        selectedEndRentalDateMillis - DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        rented = true;
        renting = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText('Operation successful'),
          content: SelectableText(
              "Token was rented successfully until ${DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(selectedEndRentalDateMillis))}"),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (exc) {
      setState(() {
        rented = false;
        renting = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText('Operation not successful'),
          content: SelectableText(
            'The operation was not completed. An error occurred: $exc',
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }
}
