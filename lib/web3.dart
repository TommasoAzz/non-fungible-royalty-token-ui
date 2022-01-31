import 'package:flutter_web3/flutter_web3.dart';

const contractABI = """[
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "symbol",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "baseURI",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "address",
          "name": "contractAddress",
          "type": "address"
        }
      ],
      "name": "CollectionDeployed",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        }
      ],
      "name": "creatorOf",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "allCollections",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "",
          "type": "address[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionOwner",
          "type": "address"
        }
      ],
      "name": "collectionsOf",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "",
          "type": "address[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "symbol",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "baseURI",
          "type": "string"
        }
      ],
      "name": "deployNewCollection",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "requireOwnershipLicenseTransferApproval",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "requireCreativeLicenseTransferApproval",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "getOwnershipLicenseTransferRequests",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "",
          "type": "address[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "getCreativeLicenseTransferRequests",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "",
          "type": "address[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    }
  ]""";

void web3() async {
  if (!Ethereum.isSupported) {
    print("Wallet not available");
    return;
  }

  final accounts = await ethereum!.requestAccount();

  print(accounts);

  final provider = Web3Provider.fromEthereum(ethereum!);

  final contract = Contract(
    "0x5138baE746f4d5D749B4668b3C24A7AE41D6F651",
    contractABI,
    provider.getSigner(),
  );

  contract.on("CollectionDeployed", (name, symbol, baseURI, contractAddress, _) {
    print("Caught event");
    print(dartify(name));
    print(dartify(symbol));
    print(dartify(baseURI));
    print(dartify(contractAddress));
    
  });

  final tx = await contract.send("deployNewCollection", [
    "NameCollection",
    "XIXIXI",
    "https://ipfs.io/ipfs/",
  ]);

  await tx.wait();
}
