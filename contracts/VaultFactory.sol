/* pragma solidity >=0.4.22 <0.7.0;

import "./Oracle.sol";
import "./DerivativeToken.sol";
import "./PayoutContract.sol";
import "./lib/ABDKMath64x64.sol";
import "./vault.sol";


 contract VaultFactory {
   address public owner;
   address public collateralToken;
   uint256 public vaultCollectionFee;
   uint256 accumulatedVaultFees;

   event VaultCreated(address vault, string name, uint256 creationFee);
   event VaultCollectionFeeUpdated(address vault, uint256 oldCreationFee, uint256 newCreationFee);

   constructor(address _collateralToken, int256 _vaultCollectionFee) {
   collateralToken = _collateralToken;
   vaultCollectionFee = _vaultCollectionFee;

 }

   function makeVault(string _name, string _symbol, address _oracle, address _payoutContract, uint256 _issuanceWeight, address _collateralToken, uint256 _issuanceTime, uint256 _settlementTime, uint256 _vaultIssuanceFee) public returns (address) {
     return new Vault(_name, _symbol, _oracle, _payoutContract, _issuanceWeight, _collateralToken, _issuanceTime, _settlementTime, _vaultIssuanceFee);
   }

   //function checkOracleValidity()

   //function checkPayoutValidity()

   //function checkTimeValidity()

   function setCollateralToken(address baseAssetContract) public onlyOwner {
     require(this.accumulatedVaultFees == 0);
     this.collateralToken = baseAssetContract;
   }

   function collectVaultCreationFee(address from, uint256 amount) internal returns (bool) {
     uint256 fee = this.vaultCreationFee(amount);
     return this.receive(this.collateralToken, from, this, amount);
   }

   function withdrawVaultFees(uint256 amount) public onlyOwner {
     require(amount <= this.accumulatedVaultFees);
     this.baseAssetContract.transferFrom(this, this.owner, amount);
   }

   function vaultCreationFee(uint256 amount) public returns (uint256 amount) {
     return ABDKMath64x64.mulu(this.vaultCreationFee, amount);
   }

   function setVaultCreationFee(uint256 newFee) onlyOwner notActive returns (bool) {
     this.vaultCreationFee = newFee;
   }

   function receive(address contract, address from, uint256 amount) internal {
     require(contract.allowance(from, this) >= amount);
     require(contract.transferFrom(from, this, amount));
   }

   function send(address contract, address recipicient, uint256 amount) internal {
        this.contract.transferFrom(this, recipicient, amount);
   }
} */
