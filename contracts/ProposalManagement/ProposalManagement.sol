pragma solidity ^0.5.0;

interface TrustTokenInterface {
    function setManagement(address) external;
    function isTrustee(address) external view returns(bool);
    function trusteeCount() external view returns(uint256);
    function lockUser(address) external returns(bool);
    function unlockUsers(address[] calldata) external;
}

interface ProposalFactoryInterface {
    function newContractFeeProposal(uint256, uint16, uint8) external returns(address);
    function newMemberProposal(address, bool, uint256, uint8) external returns(address);
}

interface ContractFeeProposalInterface {
    function vote(bool, address) external returns(bool, bool);
    function proposedFee() external view returns(uint256);
    function kill() external;
}

interface MemberProposalInterface {
    function vote(bool, address) external returns(bool, bool);
    function memberAddress() external view returns(address);
    function kill() external;
}

contract ProposalManagement {
   
    mapping(address => uint256) public proposalType;
    mapping(address => uint256) public memberId;
    mapping(address => address[]) private lockedUsersPerProposal;
    mapping(address => uint256) private userProposalLocks;
    mapping(address => address[]) private unlockUsers;
    mapping(address => uint256) private proposalIndex;

    address[] private proposals;
    address private trustTokenContract;
    address private proposalFactory;
    uint256 public contractFee;
    uint16 public minimumNumberOfVotes = 1;
    uint8 public majorityMargin = 50;
    address[] public members;

    event ProposalCreated();
    event ProposalExecuted();
    event NewContractFee();
    event MembershipChanged();

    constructor(address _proposalFactoryAddress, address _trustTokenContract) public {
        members.push(address(0));
        memberId[msg.sender] = members.length;
        members.push(msg.sender);
        contractFee = 1 ether;
        proposalFactory = _proposalFactoryAddress;
        trustTokenContract = _trustTokenContract;
        TrustTokenInterface(trustTokenContract).setManagement(address(this));
    }

    
    function createContractFeeProposal(uint256 _proposedFee) external {
        // validate input
        require(memberId[msg.sender] != 0, "not a member");
        require(_proposedFee > 0, "invalid fee");

        address proposal = ProposalFactoryInterface(proposalFactory)
            .newContractFeeProposal(_proposedFee, minimumNumberOfVotes, majorityMargin);

        // add created proposal to management structure and set correct proposal type
        proposalIndex[proposal] = proposals.length;
        proposals.push(proposal);
        proposalType[proposal] = 1;

        emit ProposalCreated();
    }

    
    function createMemberProposal(address _memberAddress, bool _adding) external {
        // validate input
        require(TrustTokenInterface(trustTokenContract).isTrustee(msg.sender), "invalid caller");
        require(_memberAddress != address(0), "invalid memberAddress");
        if(_adding) {
            require(memberId[_memberAddress] == 0, "cannot add twice");
        } else {
            require(memberId[_memberAddress] != 0, "no member");
        }

        uint256 trusteeCount = TrustTokenInterface(trustTokenContract).trusteeCount();
        address proposal = ProposalFactoryInterface(proposalFactory).newMemberProposal(_memberAddress, _adding, trusteeCount, majorityMargin);

        // add created proposal to management structure and set correct proposal type
        proposalIndex[proposal] = proposals.length;
        proposals.push(proposal);
        proposalType[proposal] = _adding ? 2 : 3;

        emit ProposalCreated();
    }

    
    function vote(bool _stance, address _proposalAddress) external {
        // validate input
        uint256 proposalParameter = proposalType[_proposalAddress];
        require(proposalParameter != 0, "Invalid address");

        bool proposalPassed;
        bool proposalExecuted;

        if (proposalParameter == 1) {
            require(memberId[msg.sender] != 0, "not a member");

            (proposalPassed, proposalExecuted) = ContractFeeProposalInterface(_proposalAddress).vote(_stance, msg.sender);
        } else if (proposalParameter == 2 || proposalParameter == 3) {
            require(TrustTokenInterface(trustTokenContract).isTrustee(msg.sender), "invalid caller");
            require(TrustTokenInterface(trustTokenContract).lockUser(msg.sender), "userlock failed");

            (proposalPassed, proposalExecuted) = MemberProposalInterface(_proposalAddress).vote(_stance, msg.sender);
            lockedUsersPerProposal[_proposalAddress].push(msg.sender);

            // update number of locks for voting user
            userProposalLocks[msg.sender]++;
        }

        emit ProposalExecuted();

        // handle return values of voting call
        if (proposalExecuted) {
            require(
                handleVoteReturn(proposalParameter, proposalPassed, _proposalAddress),
                "voteReturn failed"
            );
        }
    }

    
    function getProposalsLength() external view returns (uint256) {
        return proposals.length;
    }

    
    function getProposals() external view returns (address[] memory props) {
        return proposals.length != 0 ? proposals : props;
    }

   
    function getMembersLength() external view returns (uint256) {
        return members.length;
    }

    
    function getProposalParameters(address _proposal)
        external
        view
        returns (address proposalAddress, uint256 propType, uint256 proposalFee, address memberAddress) {
        // verify input parameters
        propType = proposalType[_proposal];
        require(propType != 0, "invalid input");

        proposalAddress = _proposal;
        if (propType == 1) {
            proposalFee = ContractFeeProposalInterface(_proposal).proposedFee();
        } else if (propType == 2 || propType == 3) {
            memberAddress = MemberProposalInterface(_proposal).memberAddress();
        }
    }

   
    function handleVoteReturn(uint256 _parameter, bool _passed, address _proposalAddress)
        private returns (bool) {
        /// case: contractFeeProposal
        if (_parameter == 1) {
            if(_passed) {
                uint256 newContractFee = ContractFeeProposalInterface(_proposalAddress).proposedFee();
                // update contract fee
                contractFee = newContractFee;
                emit NewContractFee();
            }
            // remove proposal from management contract
            removeProposal(_proposalAddress);
            return true;

        /// case: memberProposal
        } else if (_parameter == 2 || _parameter == 3) {
            if(_passed) {
                address memberAddress = MemberProposalInterface(_proposalAddress).memberAddress();
                // add | remove member
                _parameter == 2 ? addMember(memberAddress) : removeMember(memberAddress);
            }
            // get locked users for proposal
            address[] memory lockedUsers = lockedUsersPerProposal[_proposalAddress];
            for(uint256 i; i < lockedUsers.length; i++) {
                // if user is locked for 1 proposal remember user for unlocking
                if (userProposalLocks[lockedUsers[i]] == 1) {
                    unlockUsers[_proposalAddress].push(lockedUsers[i]);
                }
                // decrease locked count for all users locked for the current proposal
                userProposalLocks[lockedUsers[i]]--;
            }
            TrustTokenInterface(trustTokenContract).unlockUsers(unlockUsers[_proposalAddress]);
            // remove proposal from mangement contract
            removeProposal(_proposalAddress);
            return true;
        }

        return false;
    }

    
    function addMember(address _memberAddress) private {
        // validate input
        require(_memberAddress != address(0), "invalid address");
        require(memberId[_memberAddress] == 0, "already a member");

        memberId[_memberAddress] = members.length;
        members.push(_memberAddress);

        // if necessary: update voting parameters
        if (((members.length / 2) - 1) >= minimumNumberOfVotes) {
            minimumNumberOfVotes++;
        }

        emit MembershipChanged();
    }

    /**
     * @dev removes the member at the specified address from current members
     * @param _memberAddress the address of the member to remove
     */
    function removeMember(address _memberAddress) private {
        // validate input
        uint256 mId = memberId[_memberAddress];
        require(mId != 0, "no member");

        // move member to the end of members array
        memberId[members[members.length - 1]] = mId;
        members[mId] = members[members.length - 1];
        // removes last element of storage array
        members.pop();
        // mark memberId as invalid
        memberId[_memberAddress] = 0;

        // if necessary: update voting parameters
        if (((members.length / 2) - 1) <= minimumNumberOfVotes) {
            minimumNumberOfVotes--;
        }

        emit MembershipChanged();
    }

    
    function removeProposal(address _proposal) private {
        // validate input
        uint256 propType = proposalType[_proposal];
        require(propType != 0, "invalid request");
        if (propType == 1) {
            ContractFeeProposalInterface(_proposal).kill();
        } else if (propType == 2 || propType == 3) {
            MemberProposalInterface(_proposal).kill();
        }

        // remove _proposal from the management contract
        uint256 idx = proposalIndex[_proposal];
        if (proposals[idx] == _proposal) {
            proposalIndex[proposals[proposals.length - 1]] = idx;
            proposals[idx] = proposals[proposals.length - 1];
            proposals.pop();
        }

        // mark _proposal as invalid proposal
        proposalType[_proposal] = 0;
    }
}
