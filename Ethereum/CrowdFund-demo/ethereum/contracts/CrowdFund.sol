pragma solidity ^0.4.17;

contract CrowdFundFactory {
    address[] public deployedCrowdFunds;

    function createCrowdFund(uint256 minimum) public {
        address newCrowdFund = address(new CrowdFund(minimum, msg.sender));

        deployedCrowdFunds.push(newCrowdFund);
    }

    function getDeployedCrowdFunds() public view returns (address[] memory) {
        return deployedCrowdFunds;
    }
}

contract CrowdFund {
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 public approversCount;

    modifier managerOnly() {
        require(msg.sender == manager);
        _;
    }

    function CrowdFund(uint256 minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(
        string description,
        uint256 value,
        address recipient
    ) public managerOnly {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint256 index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finaliseRequest(uint256 index) public managerOnly {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }
}
