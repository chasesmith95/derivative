pragma solidity >=0.4.22 <0.7.0;

import "./Oracle.sol";
import "./DerivativeToken.sol";
import "./PayoutContract.sol";
import "./lib/ABDKMath64x64.sol";
import "./vault.sol";


 contract VaultFactory {
   address public owner;
   address public collateralToken;
   uint256 public vaultCreationFee;
   uint256 accumulatedVaultFees;

   event VaultCreated(address vault, string name, uint256 creationFee);
   event vaultCreationFeeUpdated(address vault, uint256 oldCreationFee, uint256 newCreationFee);

   //modifiers
   modifier onlyOwner { require(msg.sender == this.owner, "Function can only be run by the owner of this contract.");
       _;
   }

   constructor(address _collateralToken, int256 _vaultCreationFee) public {
     owner = msg.sender;
   collateralToken = _collateralToken;
   vaultCreationFee = _vaultCreationFee;
 }

   function makeVault(string memory _name, string memory _symbol, address _assetOracle, address _collateralOracle, address _payoutContract, uint256 _issuanceWeight, address _collateralToken, uint256 _issuanceTime, uint256 _settlementTime, uint256 _vaultIssuanceFee) public returns (address) {
     return new Vault(_name, _symbol, _assetOracle, _collateralOracle, _payoutContract, _issuanceWeight, _collateralToken, _issuanceTime, _settlementTime, _vaultIssuanceFee);
   }

   //function checkOracleValidity()

   //function checkPayoutValidity()

   //function checkTimeValidity()

   function setCollateralToken(address _collateralToken) public onlyOwner {
     require(this.accumulatedVaultFees == 0);
     this.collateralToken = _collateralToken;
   }

   function collectVaultCreationFee(address from, uint256 amount) internal returns (bool) {
     uint256 fee = this.calculateVaultCreationFee(amount);
     return this.receiveCollateral(this.collateralToken, from, this, amount);
   }

   function withdrawVaultFees(uint256 amount) public onlyOwner {
     require(amount <= this.accumulatedVaultFees);
     this.collateralToken.transferFrom(this, this.owner, amount);
   }

   function calculateVaultCreationFee(uint256 amount) public returns (uint256) {
     return ABDKMath64x64.mulu(this.vaultCreationFee, amount);
   }

   function setVaultCreationFee(uint256 newFee) public onlyOwner returns (bool) {
     this.vaultCreationFee = newFee;
   }

   function receiveCollateral(address contractAddress, address from, uint256 amount) internal {
     require(contractAddress.allowance(from, this) >= amount);
     require(contractAddress.transferFrom(from, this, amount));
   }

   function send(address contractAddress, address recipicient, uint256 amount) internal {
        this.contractAddress.transferFrom(this, recipicient, amount);
   }
}
