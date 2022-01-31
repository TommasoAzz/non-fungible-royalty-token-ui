import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';

class RentTokenView extends StatelessWidget {
  final String title;
  final Future<void> Function() submitRent;
  final void Function(DateTime, int) updateRentalData;
  final double rentalPricePerSecond;

  final bool rented;
  final bool renting;

  final DateTime? expirationDate;
  final int rentExpirationDateInMillis;

  const RentTokenView({
    Key? key,
    required this.title,
    required this.rented,
    required this.renting,
    required this.rentalPricePerSecond,
    required this.updateRentalData,
    required this.submitRent,
    required this.expirationDate,
    this.rentExpirationDateInMillis = 0,
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(initialDate.year + 5),
    );

    if (newDate == null) return;

    updateRentalData(newDate, (newDate.difference(DateTime.now()).inMilliseconds));
  }

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
              onPressed: () => _pickDate(context),
              child: expirationDate == null
                  ? const Text('Select date')
                  : Text('Selected date: ${DateFormat('dd/MM/yy').format(expirationDate!)}'),
            ),
            rentExpirationDateInMillis == 0
                ? const Text("")
                : Text(
                    "The cost for this rent is: ${rentExpirationDateInMillis * 1000 * rentalPricePerSecond} ETH.",
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
              onPressed: submitRent,
            ),
          ],
        ),
      ),
    );
  }
}
