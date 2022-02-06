import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../widgets/profile_token_list/profile_token_grid.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/profile_collection_list/profile_collection_grid.dart';

class ProfileContent extends StatefulWidget {
  final int column;
  final double padding;

  const ProfileContent({
    Key? key,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const PageTitle(title: "Profile"),
          const SizedBox(height: 20),
          const PageTitle(title: "Created", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
            child: ProfileCollectionGrid(
              column: widget.column,
              padding: widget.padding,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Ownership license", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: ProfileTokenGrid(
              tokenList: marketplaceVM.getOwnedTokens(),
              column: widget.column,
              padding: widget.padding,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Creative license", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: ProfileTokenGrid(
              tokenList: marketplaceVM.getCreativeOwnedTokens(),
              column: widget.column,
              padding: widget.padding,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Rented", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: ProfileTokenGrid(
              tokenList: marketplaceVM.getRentedTokens(),
              column: widget.column,
              padding: widget.padding,
            ),
          ),
        ],
      ),
    );
  }
}
