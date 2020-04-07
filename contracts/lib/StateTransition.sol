/* uint256 activationTime; //seconds
uint256 issuanceTime;
uint256 settlementTime;
uint256 issuanceDuration;
uint256 preIssuanceDuration;
bool isRepeating;


contract VaultStateMachine  {


function calculateVaultState() public returns (VaultState) {
  if (block.timestamp <= this.IssuanceTime) {
    this.state = VaultState.ACTIVATED
  } else if (block.timestamp <= this.SettlementTime) {
    this.state = VaultState.ISSUED
  } else {
    this.state = VaultState.SETTLED
  }
  return this.state;
}

function nextStage() internal {
    stage = Stages(uint(stage) + 1);
}

} */
