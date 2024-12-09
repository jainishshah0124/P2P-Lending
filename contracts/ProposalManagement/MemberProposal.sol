pragma solidity ^0.5.0;

contract MemberProposal {
    mapping(address => bool) private voted;

    address private management;
    address public memberAddress;
    bool public proposalPassed;
    bool public proposalExecuted;
    bool public adding;
    uint8 private majorityMargin;
    uint16 public numberOfVotes;
    uint16 public numberOfPositiveVotes;
    uint256 private minimumNumberOfVotes;

    constructor(
        address _memberAddress,
        bool _adding,
        uint256 _minimumNumberOfVotes,
        uint8 _majorityMargin,
        address _managementContract
    ) public {
        memberAddress = _memberAddress;
        adding = _adding;
        minimumNumberOfVotes = _minimumNumberOfVotes;
        majorityMargin = _majorityMargin;
        management = _managementContract;
    }

    
    function kill() external {
        require(msg.sender == management, "invalid caller");
        require(proposalExecuted, "!executed");
        selfdestruct(msg.sender);
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
        require(!proposalExecuted, "executed");
        require(
            numberOfVotes >= minimumNumberOfVotes,
            "cannot execute"
        );
        proposalExecuted = true;
        proposalPassed = ((numberOfPositiveVotes * 100) / numberOfVotes) >= majorityMargin;
    }
}
