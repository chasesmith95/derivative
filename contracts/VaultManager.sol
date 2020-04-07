pragma solidity >=0.4.22 <0.7.0;

import "./Oracle.sol";
import "./Vault.sol";
import "./PayoutContract.sol";

contract VaultManager {
  address owner;
  address[] payoutContracts;
  address[] oracles;
  uint256 vaultCreationFee;
  address collateralToken;

  //modifiers
  modifier onlyOwner { require(msg.sender == this.owner, "Function can only be run by the owner of this contract.");
      _;
  }

  //events
    event OracleCreated(address oracle, string name, address dataReference);
    event OracleRemoved(address oracle, string name, address dataReference);
    event OracleAdded(address oracle, string name, address dataReference);
    event VaultCreated(address vault, string name);
    event PayoutContractRemoved(address payoutContract);
    event PayoutContractAdded(address payoutContract);


  constructor(address _collateralToken, uint256 _vaultCreationFee) public {
    owner = msg.sender;
    vaultCreationFee = _vaultCreationFee;
    collateralToken = _collateralToken;
  }

  /* function createVault(address oracleAddress) public returns (uint256) {
    //this.collectVaultCreationFee(msg.sender, tradingDuration);
    return new Vault(referenceDataAddress);
  } */

  /* function createOracle(address referenceDataAddress) public returns (uint256) {
    oracle = new Oracle(referenceDataAddress);
    return oracle;
  } */



  /* function addOracle(address oracle) onlyOwner {
      this.oracles.push(oracle);
  }
    function removeOracle() onlyOwner {
      this.oracles.pop(oracle);
    } */
    function getOracles() public view returns (address[] memory) {
      return this.oracles;
    }

  /* function addPayoutContract(address payoutContract) onlyOwner {
    this.payoutContracts[payoutContract] = true;
  }
  function removePayoutContract(address payoutContract) onlyOwner {
    this.payoutContracts[payoutContract] = false;
  } */
  function getPayoutContracts() public view returns (address[] memory) {
    return this.payoutContracts;
  }

  function receiveTokens(address contractAddress, address from, uint256 amount) internal returns (bool) {
    require(contractAddress.allowance(from, this) >= amount);
    require(contractAddress.transferFrom(from, this, amount));
  }

  function withdrawFees(uint256 amount) public onlyOwner {
       if (this.accumulatedVaultFees >= amount) {
         this.collateralToken.transferFrom(this, this.owner, amount);
         this.accumulatedVaultFees -= amount;
       }
     }
  }
