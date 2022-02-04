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
          const PageTitle(title: "Profile"),
          const SizedBox(height: 20),
          const PageTitle(title: "Created", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
            child: const ProfileCollectionList(),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Ownership license", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
            child: ProfileTokenList(
              tokenList: marketplaceVM.getOwnedTokens(),
              isOwner: true,
              isCreativeOwner: false,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Creative license", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
            child: ProfileTokenList(
              tokenList: marketplaceVM.getCreativeOwnedTokens(),
              isCreativeOwner: true,
              isOwner: false,
            ),
          ),
          const SizedBox(height: 20),
          const PageTitle(title: "Rented", fontSize: 24),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
            child: ProfileTokenList(
              tokenList: marketplaceVM.getRentedTokens(),
              isCreativeOwner: false,
              isOwner: false,
            ),
          ),
        ],
      ),
    );
  }
}
