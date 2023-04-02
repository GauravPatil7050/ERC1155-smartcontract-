// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GauravToken is ERC1155, Ownable, Pausable, ERC1155Supply {

    uint256 allowListPrice = 0.001 ether;
    uint256 publicPrice = 0.01 ether;
    uint256  maxSupply = 100;
    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;


    constructor()
        ERC1155("ipfs://  Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3H  ye/")
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function uri(uint256 _id) public view virtual override returns(string memory){
        require( exists(_id),"uri does not exist");
        return string(abi.encodePacked(super.uri(_id),Strings.toString(_id),"json"))
        
    }



    function editWindow( bool _allowListMintOpen,bool _publicMintOpen)external onlyOwner{
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }



    function allowListMint( uint256 id, uint256 amount, )
        public
         payable

    {   require(allowListMintOpen,"you cannot mint now");
        require(msg.value == allowListPrice  * amount,"NOT ENOUGH AMOUNT ");
        internalMint();
    }

    function publicMint( uint256 id, uint256 amount, )
        public
         payable

    {   require(publicMintOpen,"you cannot mint now");  
        require(msg.value == publicPrice * amount,"NOT ENOUGH AMOUNT ");
       internalMint();
    }

 function internalMint() internal{
require( id < 4," you are minting invalid id");
        require(totalSupply(id) +amount <= maxSupply ,"we have been sold out");
        _mint(msg.sender, id, amount, "");


     function withdraw(address _addr)external onlyOwner{
         uint256 balance = address(this).balance;
         payable(_addr).transfer(balance);
     }

 }
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}