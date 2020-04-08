pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "@chainlink/contracts/src/v0.6/dev/AggregatorProxy.sol";

contract OracleFactory {
  function makeOracle(string memory name, string memory symbol, address referenceDataAddress) public returns (address) {
    address c = address(new Oracle(name, symbol, referenceDataAddress));
    return c;
  }
}

contract Oracle {
  string name;
  string symbol;
  AggregatorInterface internal ref;

  constructor(string memory _name, string memory _symbol, address _aggregator) public {
    ref = AggregatorProxy(_aggregator);
    name = _name;
    symbol = _symbol;
  }

  function getLatestAnswer() public view returns (int256) {
    return ref.latestAnswer();
  }

  function getLatestTimestamp() public view returns (uint256) {
    return ref.latestTimestamp();
  }

  function getPreviousAnswer(uint256 _back) public view returns (int256) {
    uint256 latest = ref.latestRound();
    require(_back <= latest, "Not enough history");
    return ref.getAnswer(latest - _back);
  }

  function getPreviousTimestamp(uint256 _back) public view returns (uint256) {
    uint256 latest = ref.latestRound();
    require(_back <= latest, "Not enough history");
    return ref.getTimestamp(latest - _back);
  }
}
