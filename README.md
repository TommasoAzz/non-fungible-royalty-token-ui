# non-fungible-royalty-token-ui

A university project for implementing a marketplace of a slightly modified version of the ERC1190 proposal "Non-Fungible Royalty Token".

Made for the course "Blockchain and Cryptocurrencies", University of Bologna, A.Y. 2021/2022.

This is part of the parent repository [non-fungible-royalty-token](https://github.com/TommasoAzz/non-fungible-royalty-token).
Here is a website mocking the famous [OpenSea](https://opensea.io/) which allows to deploy new collections, tokens, manage licenses, rent tokens.

## Prerequisites and steps to continue developing this project
### Requirements

- [Flutter](https://flutter.dev) (compulsory),
- a crypto wallet, we advise [MetaMask](https://metamask.io/) (compulsory),
- an [IPFS](https://ipfs.io/) node running in your local machine (compulsory for deploying new collections or mint/view tokens).

### Initial setup

- `flutter pub get`

### Other commands

- View the website (development purposes): `flutter run -d web-server` (it needs the IPFS node on on your local machine and the wallet set to Rinkeby for utilizing the already deployed smart contract)