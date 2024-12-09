pragma solidity ^0.5.0;

contract ContractFeeProposal {
    mapping(address => bool) private voted;

    address payable private management;
    uint8 private majorityMargin;
    uint16 private minimumNumberOfVotes;
    uint16 public numberOfVotes;
    uint16 public numberOfPositiveVotes;
    uint256 public proposedFee;
    bool public proposalPassed;
    bool public proposalExecuted;

    constructor(
        uint256 _proposedFee,
        uint16 _minimumNumberOfVotes,
        uint8 _majorityMargin,
        address payable _managementContract
    ) public {
        proposedFee = _proposedFee;
        minimumNumberOfVotes = _minimumNumberOfVotes;
        majorityMargin = _majorityMargin;
        management = _managementContract;
    }

    /**
     * @notice destroys the proposal contract and forwards the remaining funds to the management contract
     */
    function kill() external {
        require(msg.sender == management, "invalid caller");
        require(proposalExecuted, "!executed");
        selfdestruct(management);
    }

    
    function vote(bool _stance, address _origin) external returns (bool propPassed, bool propExecuted) {
        // check input parameters
        require(msg.sender == management, "invalid caller");
        require(!proposalExecuted, "executed");
        require(!voted[_origin], "second vote");

        // update internal state
        voted[_origin] = true;
        numberOfVotes += 1;
        if (_stance) numberOfPositiveVotes++;

        // check if execution of proposal should be triggered and update return values
        if ((numberOfVotes >= minimumNumberOfVotes)) {
            execute();
            propExecuted = true;
            propPassed = proposalPassed;
        }
    }

    
    function execute() private {
        // check internal state
        require(!proposalExecuted, "executed");
        require(
            numberOfVotes >= minimumNumberOfVotes,
            "cannot execute"
        );

        // update the internal state
        proposalExecuted = true;
        proposalPassed = ((numberOfPositiveVotes * 100) / numberOfVotes) >= majorityMargin;
    }
}
