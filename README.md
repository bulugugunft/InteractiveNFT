## InteractiveNFT
A demo contract of `native-user-interactive` NFT， The `native-user-interactive` means that user can interactive with the NFT(`tokenId`) with no need of specific deployed front-end app. 

##  Motivation

Currently, most ERC-721 instances are static images or items, like profile pictures,  avatar in games or lands in metaverse world, There are some projects would like to build `interactive NFT`, which means user could interact with the NFT and then the metadata of NFT changed simultaneously. It's naturally a good direction of NFT evolution.

The basic logic to develop an `interactive NFT` is define some attributes of the NFT in smart contract and provide interface which is to modify the attributes. When the attributes of the NFT changed, the storage that saved the metadata of NFT updates simultaneously. It usually needs to deploy a specific website by which users can interactive with the NFTs, but it is not always a reliable way, as mentioned by the developer of a well-known `interactive NFT` project `CryptOrchids` :

"*The drawback of using the website to water your plants is that you are depending on the website to exist, to be up, to not have any bugs. The source code for this website is not (yet?) open source, so if I end up not being able to pay my hosting bill, you may not be able to water your plants.*"

Yes, it's no doubt that user can use [Etherscan](https://etherscan.io/), locate to the correct contract address and input the parameters of each function to  interactive with the NFT, but it's really not user-friendly. 

Here the proposal is to add a `script` data for the standard NFT contract, the `script` contains the operation methods of the NFTs, usually it's written by Javascript. Every 3rd web page could query the `script` from the NFT contract and embedded into its page, and then it would be ready for user to interactive with the NFTs.

## The demo

In this Demo, the NFT is defined with several attributes, and the contract contrains the functions to modify them. The `script` is written in Javascript which will be set in the contract by calling `setScript()`, any 3rd website could query the `script` and embedded it in the page, and then user could interact with the NFT.

How to run this Demo:

- Deploy this [contract](https://github.com/bulugugunft/InteractiveNFT/blob/main/contracts/InteractiveNFT.sol) to Rinkeby(or others) testnet
- Encode [script](https://github.com/bulugugunft/interactiveNFTWebDemo/blob/main/file.js) to Base64
- Call `setScript()` of the depolyed contract, parameter is the Base64 encoding of the previous step
- Call `mint()` to mint a NFT
- Run a http server to load [web](https://github.com/bulugugunft/interactiveNFTWebDemo/blob/main/index.html)
- Enter contract address and NFT id in the input box and click the Query button, then NFT will load on the web page
- Click `change color` on the NFT will pop-up Metamask and user needs to sign，the color will change from black to blue.
- Click `change text` on the NFT will pop-up Metamask and user needs to sign，if the text is "good morning", will change to "good night", if the text is "good night", will change to "good morning".
