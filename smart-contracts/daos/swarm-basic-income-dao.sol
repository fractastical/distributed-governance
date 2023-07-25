
// Tweaked version

/* The token is used as a voting shares */
contract token { mapping (address => uint256) public balanceOf;  }

/* The democracy contract itself */
contract Democracy {

    /* Contract Variables and events */
    uint public minimumQuorum;
    uint public debatingPeriodInMinutes;
    Proposal[] public proposals;
    uint public numProposals;
    token public sharesTokenAddress;

    event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
    event Voted(uint proposalID, bool position, address voter);
    event ProposalTallied(uint proposalID, int result, uint quorum, bool active);

    struct Proposal {
        address recipient;
        uint amount;
        string description;
        uint votingDeadline;
        bool openToVote;
        bool proposalPassed;
        uint numberOfVotes;
        bytes32 proposalHash;
        Vote[] votes;
        mapping (address => bool) voted;
    }

    struct Vote {
        bool inSupport;
        address voter;
    }

    /* modifier that allows only shareholders to vote and create new proposals */
    modifier onlyShareholders {
        if (sharesTokenAddress.balanceOf(msg.sender) == 0) throw;
        _
    }

    /* First time setup */
    function Democracy(token sharesAddress, uint minimumSharesForVoting, uint minutesForDebate) {
        sharesTokenAddress = token(sharesAddress);
        if (minimumSharesForVoting == 0 ) minimumSharesForVoting = 1;
        minimumQuorum = minimumSharesForVoting;
        debatingPeriodInMinutes = minutesForDebate;
    }

    /* Function to create a new proposal */
    function newProposal(address beneficiary, uint etherAmount, string JobDescription, bytes transactionBytecode) onlyShareholders returns (uint proposalID) {
        proposalID = proposals.length++;
        Proposal p = proposals[proposalID];
        p.recipient = beneficiary;
        p.amount = etherAmount;
        p.description = JobDescription;
        p.proposalHash = sha3(beneficiary, etherAmount, transactionBytecode);
        p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
        p.openToVote = true;
        p.proposalPassed = false;
        p.numberOfVotes = 0;
        ProposalAdded(proposalID, beneficiary, etherAmount, JobDescription);
        numProposals = proposalID+1;
    }

    /* function to check if a proposal code matches */
    function checkProposalCode(uint proposalNumber, address beneficiary, uint etherAmount, bytes transactionBytecode) constant returns (bool codeChecksOut) {
        Proposal p = proposals[proposalNumber];
        return p.proposalHash == sha3(beneficiary, etherAmount, transactionBytecode);
    }

    /* */
    function vote(uint proposalNumber, bool supportsProposal) onlyShareholders returns (uint voteID){
        Proposal p = proposals[proposalNumber];
        if (p.voted[msg.sender] == true) throw;

        voteID = p.votes.length++;
        p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});
        p.voted[msg.sender] = true;
        p.numberOfVotes = voteID +1;
        Voted(proposalNumber,  supportsProposal, msg.sender);
    }

    function executeProposal(uint proposalNumber, bytes transactionBytecode) returns (int result) {
        Proposal p = proposals[proposalNumber];
        /* Check if the proposal can be executed */
        if (now < p.votingDeadline  /* has the voting deadline arrived? */
            || !p.openToVote        /* has it been already executed? */
            ||  p.proposalHash != sha3(p.recipient, p.amount, transactionBytecode)) /* Does the transaction code match the proposal? */
            throw;

        /* tally the votes */
        uint quorum = 0;
        uint yea = 0;
        uint nay = 0;

        for (uint i = 0; i <  p.votes.length; ++i) {
            Vote v = p.votes[i];
            uint voteWeight = sharesTokenAddress.balanceOf(v.voter);
            quorum += voteWeight;
            if (v.inSupport) {
                yea += voteWeight;
            } else {
                nay += voteWeight;
            }
        }
        /* execute result */
        if (quorum > minimumQuorum && yea > nay ) {
            // has quorum and was approved
            p.recipient.call.value(p.amount*1000000000000000000)(transactionBytecode);
            p.openToVote = false;
            p.proposalPassed = true;
        } else if (quorum > minimumQuorum && nay > yea) {
            p.openToVote = false;
            p.proposalPassed = false;
        }
        /* Fire Events */
        ProposalTallied(proposalNumber, result, quorum, p.openToVote);
    }
}
