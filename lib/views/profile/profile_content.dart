import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../widgets/profile_token_list/profile_token_grid.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/profile_collection_list/profile_collection_grid.dart';

class ProfileContent extends StatelessWidget {
  final int column;
  final double padding;

  const ProfileContent({
    Key? key,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const PageTitle(title: "Profile"),
          const SizedBox(height: 20),
          const PageTitle(title: "Created", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
            child: ProfileCollectionGrid(
              column: column,
              padding: padding,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Ownership license", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: ProfileTokenGrid(
              tokenList: marketplaceVM.getOwnedTokens(),
              isOwner: true,
              isCreativeOwner: false,
              column: column,
              padding: padding,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Creative license", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: ProfileTokenGrid(
              tokenList: marketplaceVM.getCreativeOwnedTokens(),
              isCreativeOwner: true,
              isOwner: false,
              column: column,
              padding: padding,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Rented", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: ProfileTokenGrid(
              tokenList: marketplaceVM.getRentedTokens(),
              isCreativeOwner: false,
              isOwner: false,
              column: column,
              padding: padding,
            ),
          ),
        ],
      ),
    );
  }
}
