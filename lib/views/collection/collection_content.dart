import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/models/token.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../constants/app_colors.dart';
import '../../locator.dart';
import '../../widgets/dropzone/dropzone.dart';
import '../../widgets/number_slider_form_field/number_slider_form_field.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/token_item/token_item.dart';

class CollectionContent extends StatefulWidget {
  const CollectionContent({
    Key? key,
    required this.column,
    required this.padding,
  }) : super(key: key);

  final int column;
  final double padding;

  @override
  State<CollectionContent> createState() => _CollectionContentState();
}

class _CollectionContentState extends State<CollectionContent> {
  final marketplaceVM = locator<MarketplaceVM>();

  @override
  void initState() {
    super.initState();
    marketplaceVM.addListener(update);
  }

  @override
  void dispose() {
    marketplaceVM.removeListener(update);
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    final collectionData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    late Future<Collection> futureCollection;
    if (collectionData['collection'] != null) {
      futureCollection = Future.value(Collection.fromMap(collectionData['collection']));
    } else if (collectionData['collection_address'] != null) {
      futureCollection = marketplaceVM.getCollection(collectionData['collection_address']);
    } else {
      return const SelectableText("Error loading the collection.");
    }

    return FutureBuilder<Collection>(
        future: futureCollection,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final collection = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                PageTitle(title: collection.name),
                const SizedBox(height: 20),
                const PageTitle(title: "Tokens", fontSize: 24),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: FutureBuilder<List<Token>>(
                    future: marketplaceVM.getTokens(collection),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return SelectableText("Error: ${snapshot.error}");
                      }

                      if (snapshot.data!.isEmpty) {
                        return const SelectableText("There are no tokens for collection.");
                      }

                      return GridView.count(
                        childAspectRatio: 0.65,
                        primary: false,
                        padding: EdgeInsets.all(widget.padding),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        crossAxisCount: widget.column,
                        children: snapshot.data!
                            .map((token) => TokenItem(
                                  isCreativeOwner:
                                      token.creativeOwner == marketplaceVM.loggedAccount,
                                  isOwner: token.owner == marketplaceVM.loggedAccount,
                                  token: token,
                                  collection: collection,
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),
                if (collection.creator == marketplaceVM.loggedAccount)
                  Padding(
                    padding: EdgeInsets.all(widget.padding),
                    child: const PageTitle(title: "Add new tokens", fontSize: 24),
                  ),
                if (collection.creator == marketplaceVM.loggedAccount)
                  _AddTokens(
                    padding: widget.padding,
                    collection: collection,
                  ),
              ],
            ),
          );
        });
  }
}

class _AddTokens extends StatefulWidget {
  final double padding;
  final Collection collection;

  const _AddTokens({
    Key? key,
    required this.padding,
    required this.collection,
  }) : super(key: key);

  @override
  State<_AddTokens> createState() => _AddTokensState();
}

class _AddTokensState extends State<_AddTokens> {
  final marketplaceVM = locator<MarketplaceVM>();

  bool collectionUploaded = false;
  bool uploadingCollection = false;

  int _ownershipTransferRoyalty = 0;
  int _rentalRoyalty = 0;

  final _fileUrls = <String>[];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Column(
        children: [
          NumberSliderFormField(
            title: "Set royalty (%) for ownership transfer",
            saveValue: _saveOwnershipTransferInputField,
          ),
          NumberSliderFormField(
            title: "Set royalty (%) for rental",
            saveValue: _saveRentalInputField,
          ),
          const SizedBox(
            height: 20,
          ),
          Dropzone(
            saveUrl: _saveUrlFromDropzone,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (collectionUploaded)
                  const Text(
                    "Submitted",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                if (collectionUploaded) const Icon(Icons.check, size: 16),
                if (!collectionUploaded)
                  const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                if (uploadingCollection) const SizedBox(width: 10),
                if (uploadingCollection)
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
            onPressed: () => _submitData(widget.collection),
          ),
        ],
      ),
    );
  }

  void _saveOwnershipTransferInputField(final double value) =>
      _ownershipTransferRoyalty = value.toInt();

  void _saveRentalInputField(final double value) => _rentalRoyalty = value.toInt();

  void _saveUrlFromDropzone(final String value) => _fileUrls.add(value);

  Future<void> _submitData(final Collection collection) async {
    setState(() {
      uploadingCollection = true;
    });

    try {
      await marketplaceVM.mintTokens(
        collection.address,
        _rentalRoyalty,
        _ownershipTransferRoyalty,
        _fileUrls,
      );

      setState(() {
        collectionUploaded = true;
        uploadingCollection = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText('Successfully minted tokens'),
          content: SelectableText(
            'Collection ${collection.name} (${collection.symbol}) was updated successfully with ${_fileUrls.length} new tokens.',
          ),
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
        collectionUploaded = false;
        uploadingCollection = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText('Mint not successful'),
          content: SelectableText(
            'The tokens were not deployed. An error occurred: $exc',
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
