pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Vault
 * @def
*/
contract Vault {
    address owner;
    address[] public derivatives;
    mapping (address => address[]) public userDerivatives;
    uint256 public vaultFee;
    uint256 accumulatedVaultFees;
    bool isActive;
    //mapping(address => uint256) contractBalances;
    //mapping (address => bool) public acceptedCollateralTokens;

    //modifiers

    //onlyOwner 
    modifier onlyOwner { require(msg.sender == this.owner, "Function can only be run by the owner of this contract.");
        _;
    }

    //notPaused
    modifier notPaused { require(this.isActive, "Contract must not be paused.");
        _;
    }

    //notActive
    modifier notActive { require(this.isActive == false, "Contract must not be active.");
        _;
    }


    constructor(uint256 vaultFee) {
      super()
      this.vaultFee = fee
      this.isActive = true;
      //init everything else
    }

    function issueDerivative(address derivative, uint256 amount) public external returns (bool) notPaused holdDerivate {
      if (this.collectFee(msg.sender, amount)) {
        derivative.issueDerivative(msg.sender, amount)
        return true
      }
      return false
    }

    function collectFee(address from, uint256 amount) public returns (bool) {
      fee = this.calculateFee(amount)
      successful = receive(this.baseAssetContract, from, this, amount)
      return true
    }

    function calcuateFee(uint256 amount) public returns (uint256 amount) {
      return (this.vaultFee * amount)
    }

  function updateVaultFee(uint256 newFee) onlyOwner returns (bool) onlyOwner notActive {
      this.vaultFee = newFee
  }

  function withdrawFees(uint256 amount) public external onlyOwner {
       if (this.accumulatedVaultFees >= amount) {
         this.baseAsset.transferFrom(contract, this, this.owner, amount)
         this.accumulatedVaultFees -= amount
       }
     }
  }

    function receive(address contract, address from, address derivative, uint256 amount) private external returns (bool) {
    contract.transferFrom(this, derivative, amount)
    }

    function accountWithdrawal(address derivative, uint256 amount) public external {
      derivative.accountWithdrawal(amount)
    }

    function accountDeposit(uint256 amount) public external {
      derivative.accountDeposit(amount)
    }

    function addDerivative(address derivativeAddress) public onlyOwner {
        this.assets[derivativeAddress] = true
    }

    function removeDerivative(address derivativeAddress) public onlyOwner {
        this.assets[derivativeAddress] = false
    }

    function getDerivatives() public returns (address[]) {
        return this.derivatives
    }
}
