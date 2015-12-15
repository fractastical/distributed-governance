// koeppelmann
// via https://raw.githubusercontent.com/koeppelmann/circles/master/circles.sol

contract Circles {
    mapping (address => AccountValues) public accounts;
    mapping (address => mapping (address => uint)) public balances;
    mapping (address => mapping (address => bool)) public trustees;

    struct AccountValues {
        uint created;
        uint spend;
        uint trustee_reward;
    }

    function Circles() {
    }


    function addAcount() {
        accounts[msg.sender].created = block.timestamp - 2592000; //date 1 month back
        accounts[msg.sender].spend = 0;
        accounts[msg.sender].trustee_reward = 2592000 * 2 / 6;
    }


    function sendMoney(address receiver, address currency, uint amount) returns(bool sufficient) {
        if (balances[msg.sender][currency] < amount) return false;
        balances[msg.sender][currency] -= amount;
        balances[receiver][currency] += amount;
        return true;
    }

    function getAmount(address currency) returns(uint amount){
        return balances[msg.sender][currency];
    }

    function getNewIncomeAvailable() returns(uint amount){
       return ((block.timestamp - accounts[msg.sender].created) / 6) - accounts[msg.sender].spend;
    }


    function sendNewIncome(address receiver, uint amount) returns(bool sufficient) {
        //todo factor in 2% growth rate
        uint income_generated = (block.timestamp - accounts[msg.sender].created) / 6;
        if ((income_generated - accounts[msg.sender].spend) >= amount){
            accounts[msg.sender].spend += amount;
            balances[receiver][msg.sender] += amount;}
    }

    function addTrust(uint8 v, bytes32 r, bytes32 s) returns(bool succeeded) {
        if (trustees[msg.sender][trustee]) false;

        address trustee = ecrecover(sha256(msg.sender, "WillingToExchange1to1"), v, r, s);


        trustees[msg.sender][trustee] = true;
        trustees[trustee][msg.sender] = true;
        //payout trustees reward
        balances[msg.sender][trustee] += accounts[trustee].trustee_reward / 10;
        balances[trustee][msg.sender] += accounts[msg.sender].trustee_reward / 10;
        accounts[trustee].trustee_reward -= accounts[trustee].trustee_reward / 10;
        accounts[msg.sender].trustee_reward -= accounts[msg.sender].trustee_reward / 10;
        return true;
    }

    function revokeTrust(address trustee) returns(bool succeeded){
        trustees[msg.sender][trustee] = false;
        trustees[trustee][msg.sender] = false;
        return true;
    }


    function forwardMoney(address receiver, address hop1, uint amount) returns(bool succeeded) {
        if (!trustees[msg.sender][hop1]) return false;
        if (balances[msg.sender][msg.sender] < amount) return false;
        if (balances[hop1][hop1] < amount) return false;
        balances[msg.sender][msg.sender] -= amount;
        balances[hop1][hop1] -= amount;
        balances[hop1][msg.sender] += amount;
        balances[receiver][hop1] += amount;
        return true;

    }

    /*
    function convertIntoGroupMoney(address group, unit amount){
        if (msg.sender in groups[group]) {
            if (balances[msg.sender][msg.sender] >= amount){
                balances[msg.sender][message.sender] -= amount
                balances[msg.sender][group] += amount
            }
        }
    }
    */

}




/*
Dictionary -> Set
groups[owner] =  [member1, member2 ,..]
Dictionary -> Set
trustees[account] = [account1, account2, …] // each relationship need only be saved once
Dictionary – > Dictionary -> int
balance[owner][foreign_account] = amount
Int
years = 0
//pseudo code



revoke_trust(account):
    if int(message.sender) > account:
        trustees[message.sender].remove(account)
    else:
        trustees[account].remove(message.sender)
send_money(amount, currency, receiver):
    if balance[message.sender][currency] >= amount:
        balance[message.sender][currency] -= amount
        balance[receiver][currency] += amount
exchange_money(account1, account2, amount)
    if message.sender == account1 or message.sender == account2:
        if account2 in trustees[account1]:
            if balance[account1][account1] >= amount:
                if balance[account2][account2] >= amount:
                    balance[account1][account1] -= amount
                    balance[account2][account2] -= amount
                    balance[account1][account2] += amount
                    balance[account2][account1] += amount
create_group()
    groups[message.sender] = Set()

add_group_member(account)
    groups[message.sender].add(account)
remove_groupt_member(account)
    groups[message.sender].remove(account)

*/
