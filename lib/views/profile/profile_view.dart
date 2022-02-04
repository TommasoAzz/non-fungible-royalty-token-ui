import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../widgets/profile_token_list/profile_token_list.dart';
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
          const PageTitle(title: "My Profile"),
          const SizedBox(height: 20),
          const ProfileCollectionList(title: "Created"),
          const SizedBox(height: 20),
          ProfileTokenList(
            title: "Ownership license",
            tokenList: marketplaceVM.getOwnedTokens(),
            isCreativeOwner: false,
            isOwner: true,
          ),
          const SizedBox(height: 20),
          ProfileTokenList(
            title: "Creative license",
            tokenList: marketplaceVM.getCreativeOwnedTokens(),
            isCreativeOwner: true,
            isOwner: false,
          ),
          const SizedBox(height: 20),
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
