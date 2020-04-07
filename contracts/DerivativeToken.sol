/* pragma solidity >=0.4.22 <0.7.0;
import "@openzeppelin/contracts/deploy-ready/ERC20MinterPauser.sol";

contract DerivativeToken is ERC20MinterPauser {
  constructor(string memory name, string memory symbol) public {
      ERC20MinterPauser(name, symbol);
  }
  function mintToken(address account, uint256 amount) public {
    this._mint(account, amount);
  }
} */
