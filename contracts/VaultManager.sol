

contract MasterContract {
  address owner;
  address[] payoutContracts;
  address[] oracles;
  uint256 public vaultCollectionFee;
  uint256 accumulatedVaultFees;
  uint256 baseAssetContract;

  //modifiers
  modifier onlyOwner { require(msg.sender == this.owner, "Function can only be run by the owner of this contract.");
      _;
  }

  constructor(uint256 vaultFee) {
    super();
    vaultCreationFee = vaultFee;
    owner = msg.sender;
    accumulatedVaultFees = 0;
    oracles;
    payoutContracts;
    baseAssetContract;
  }


  function createVault(address oracleAddress) public returns (uint256) {
    this.collectVaultCreationFee(msg.sender, tradingDuration);
    vault = new Vault(referenceDataAddress);
    //ensure that vault can mint the erc20 contracts
    return vault;
  }

  function createOracle(address referenceDataAddress) public returns (uint256) {
    oracle = new Oracle(referenceDataAddress);
    return oracle;
  }

  function collectVaultCreationFee(address from, uint256 amount) internal returns (bool) {
    fee = this.vaultCreationFee(amount)
    successful = receive(this.baseAssetContract, from, this, amount)
    return true
  }
  function vaultCreationFee(uint256 amount) public returns (uint256 amount) {
    return (this.vaultCreationFee * amount)
  }
  function setVaultCreationFee(uint256 newFee) onlyOwner returns (bool) onlyOwner notActive {
    this.vaultCreationFee = newFee
  }

  function setBaseAsset(address baseAssetContract) onlyOwner {
    require(isAsset)
    require(balance 0)
    this.baseAssetContract = baseAssetContract
  }

  function addOracle(address oracle) onlyOwner {
      require(isOracle)
      this.oracles.push()
  }
    function removeOracle() onlyOwner {
      this.oracleAddress
    }
    function getOracles() public view returns (address[]) {
      return this.oracles
    }

  function addPayoutContract(address payoutContract) onlyOwner {
    require(isPayoutContract)
    this.payoutContracts[payoutContract] = true;
  }
  function removePayoutContract(address payoutContract) onlyOwner {
    this.payoutContracts[payoutContract] = false;
  }
  function getPayoutContracts() public view returns (address[]) {
    return this.payoutContracts
  }


  function receive(address contract, address from, address derivative, uint256 amount) private external returns (bool) {
    require(myToken.allowance(msg.sender, this) > 0);
  uint tokenAmount = myToken.allowance(msg.sender, this);
  require(myToken.transferFrom(msg.sender, this, tokenAmount));
  msg.sender.transfer(getRate(tokenAmount));
  }

  function withdraw(uint256 amount) public external onlyOwner {
       if (this.accumulatedVaultFees >= amount) {
         this.baseAsset.transferFrom(contract, this, this.owner, amount)
         this.accumulatedVaultFees -= amount
       }
     }
  }


}
