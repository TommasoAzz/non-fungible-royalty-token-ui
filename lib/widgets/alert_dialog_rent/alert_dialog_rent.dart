import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/constants/app_colors.dart';

class AlertDialogRent extends StatefulWidget {
  final String title;
  final void Function() submitRent;
  final double rentalPricePerSecond;
  final void Function(BuildContext) pickDate;

  bool rented;
  bool renting;
  int rentExpirationDateInMillis;
  DateTime? expirationDate;

  AlertDialogRent(
      {Key? key,
      required this.pickDate,
      required this.title,
      required this.expirationDate,
      required this.rentExpirationDateInMillis,
      required this.rented,
      required this.renting,
      required this.rentalPricePerSecond,
      required this.submitRent})
      : super(key: key);

  @override
  _AlertDialogRentState createState() => _AlertDialogRentState();
}

class _AlertDialogRentState extends State<AlertDialogRent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 700,
      child: AlertDialog(
        title: const Text("Rent this token"),
        content: Column(
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
              onPressed: () => widget.pickDate(context),
              child: widget.expirationDate == null
                  ? const Text('Select date')
                  : Text(
                      'Selected date: ${DateFormat('dd/MM/yy').format(widget.expirationDate!)}'),
            ),
            widget.rentExpirationDateInMillis == 0
                ? const Text("")
                : Text(
                    "The cost for this rent is: ${widget.rentExpirationDateInMillis * 1000 * widget.rentalPricePerSecond} ETH",
                  ),
            ElevatedButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.rented)
                    const Text(
                      "Submitted",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  if (widget.rented) const Icon(Icons.check_box, size: 16),
                  if (!widget.rented)
                    const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  if (widget.renting) const SizedBox(width: 10),
                  if (widget.renting)
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
              onPressed: widget.submitRent,
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> pickDate(BuildContext context) async {
  //   final initialDate = DateTime.now();
  //   final newDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: initialDate,
  //     lastDate: DateTime(initialDate.year + 5),
  //   );

  //   if (newDate == null) return;
  //   setState(() {
  //     widget.expirationDate = newDate;
  //     widget.rentExpirationDateInMillis =
  //         (widget.expirationDate!.difference(DateTime.now()).inMilliseconds);
  //   }
  // );
  //}
}
