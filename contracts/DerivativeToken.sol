pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract DerivativeToken is ERC777 {
  constructor(string name, string symbol, address[] memory defaultOperators) public {
      ERC777(name, symbol, defaultOperators);
  }
  function mint(address account, uint256 amount) onlyOwner public {
    _mint(account, amount);
  }
}
