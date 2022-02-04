import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/locator.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/profile_token_list/profile_token_list.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/profile_collection_list/profile_collection_list.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          PageTitle(title: "My Profile"),
          SizedBox(
            height: 20,
          ),
          ProfileCollectionList(title: "Created"),
          SizedBox(
            height: 20,
          ),
          ProfileTokenList(
            title: "Ownership license",
            tokenList: marketplaceVM.getOwnedTokens(),
            isCreativeOwner: false,
            isOwner: true,
          ),
          SizedBox(
            height: 20,
          ),
          ProfileTokenList(
            title: "Creative license",
            tokenList: marketplaceVM.getCreativeOwnedTokens(),
            isCreativeOwner: true,
            isOwner: false,
          ),
          SizedBox(
            height: 20,
          ),
          ProfileTokenList(
            title: "Rented",
            tokenList: marketplaceVM.getRentedTokens(),
            isCreativeOwner: false,
            isOwner: false,
          )
        ],
      ),
    );
  }
}
