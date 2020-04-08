pragma solidity >=0.4.22 <0.7.0;

import "./Oracle.sol";
//import "./DerivativeToken.sol";
import "./PayoutContract.sol";
import "./lib/ABDKMath64x64.sol";
import "./Vault.sol";
import "./lib/ABDKMath64x64.sol";
import "@openzeppelin/contracts/deploy-ready/ERC20MinterPauser.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 contract VaultFactory {
   address public owner;
   ERC20 public collateralToken;
   uint256 public vaultCreationFee;
   uint256 accumulatedVaultFees;

   event VaultCreated(address vault, string name, uint256 creationFee);
   event vaultCreationFeeUpdated(address vault, uint256 oldCreationFee, uint256 newCreationFee);

   //modifiers
   modifier onlyOwner { require(msg.sender == owner, "Function can only be run by the owner of this contract.");
       _;
   }

   constructor(ERC20 _collateralToken, uint256 _vaultCreationFee) public {
     owner = msg.sender;
     collateralToken = _collateralToken;
   vaultCreationFee = _vaultCreationFee;
 }
/*
   function makeVault(string memory _name, string memory _symbol, Oracle _assetOracle, Oracle _collateralOracle, PayoutContract _payoutContract, uint256 _issuanceWeight, ERC20 _collateralToken, uint256 _issuanceTime, uint256 _settlementTime, uint256 _vaultIssuanceFee) public returns (Vault) {
     return (new Vault(_name, _symbol, _assetOracle, _collateralOracle, _payoutContract, _issuanceWeight, _collateralToken, _issuanceTime, _settlementTime, _vaultIssuanceFee));
   }

   //function checkOracleValidity()

   //function checkPayoutValidity() */

   //function checkTimeValidity()

   function setCollateralToken(ERC20 _collateralToken) public onlyOwner {
     require(accumulatedVaultFees == 0);
     collateralToken = _collateralToken;
   }

   function collectVaultCreationFee(address from, uint256 amount) internal {
     uint256 fee = calculateVaultCreationFee(amount);
     receiveToken(collateralToken, from, fee);
   }

   function withdrawVaultFees(uint256 amount) public onlyOwner {
     require(amount <= accumulatedVaultFees);
     collateralToken.transferFrom(address(this), owner, amount);
   }

   function calculateVaultCreationFee(uint256 amount) public returns (uint256) {
     return ABDKMath64x64.mulu(int128(vaultCreationFee), amount);
   }

   function setVaultCreationFee(uint256 newFee) public onlyOwner returns (bool) {
     vaultCreationFee = newFee;
   }

   function receiveToken(ERC20 contractAddress, address from, uint256 amount) internal {
     require(contractAddress.allowance(from, address(this)) >= amount);
     require(contractAddress.transferFrom(from, address(this), amount));
   }

   function sendToken(ERC20 contractAddress, address recipicient, uint256 amount) internal {
        contractAddress.transferFrom(address(this), recipicient, amount);
   }
}
