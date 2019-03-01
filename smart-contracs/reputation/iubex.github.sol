
//See: https://github.com/iudex/iudex/blob/master/contracts/github.sol

//
// This contract will validate that a github gist url:
// 1) corresponds to a given username
// 2) containts an expected message (the user identifier)
//

import "accountProviderBase.sol";

contract Github is accountProviderBase {
  Lookup lookup;

  address owner;

  modifier owneronly { if (msg.sender == owner) _ }

  function setOwner(address addr) owneronly {
    owner = addr;
  }

  function Github() {
    owner = msg.sender;
  }

  function setLookup(address addr) owneronly {
    lookup = Lookup(addr);
  }

  // map the expected identifier to an oraclize identifier
  mapping (bytes32 => bytes32) expectedId;

  // callback from oraclize with the result, let the storage contract know
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;

    // this is basically a bytes32 to hexstring piece
    string memory expected = iudexIdToString(expectedId[myid]);
    bool asExpected = indexOf(result, expected) > -1;
    Storage(lookup.addrStorage()).updateAccount(lookup.accountProvider_GITHUB(), expectedId[myid], asExpected, myid);
    delete expectedId[myid];
  }

  function score(bytes32 id, string userId) coupon("HackEtherCamp") {
    throw;
  }

  // ensure that the proofLocation corresponds to a gist.github.com URL for the user `userId`
  function verifyUrl(string userId, string proofLocation) internal returns (bool){
    bytes memory _userId = bytes(userId);
    string memory githubPrefix = "://gist.github.com/";
    bytes memory _githubPrefix = bytes(githubPrefix);
    string memory urlHead = new string(_githubPrefix.length + _userId.length + 1);
    bytes memory _urlHead = bytes(urlHead);
    uint i = 0;
    for (uint j = 0; j < _githubPrefix.length; j++)
      _urlHead[i++] = _githubPrefix[j];
    for (j = 0; j < _userId.length; j++)
      _urlHead[i++] = _userId[j];
    _urlHead[i++] = byte("/");

    if (indexOf(proofLocation, string(_urlHead)) == -1)
      return false;

    return true;
  }

  // start the verification process and call oraclize with the URL
  function verify(bytes32 id, string userId, string proofLocation) coupon("HackEtherCamp") {
    // check that userId matches the username in proofLocation
    if (!verifyUrl(userId, proofLocation))
      throw;

    // build up the request string
    string memory head = "html(";
    bytes memory _head = bytes(head);
    string memory tail = ").xpath(//*[contains(@class, 'blob-code')]/text())";
    bytes memory _tail = bytes(tail);

    bytes memory _gistUrl = bytes(proofLocation);

    string memory query = new string(_head.length + _tail.length + _gistUrl.length + 2);
    bytes memory _query = bytes(query);
    uint i = 0;
    for (uint j = 0; j < _head.length; j++)
      _query[i++] = _head[j];
    for (j = 0; j < _gistUrl.length; j++)
      _query[i++] = _gistUrl[j];
    for (j = 0; j < _tail.length; j++)
      _query[i++] = _tail[j];
    _query[i++] = 0;

    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    bytes32 oraclizeId = oraclize_query("URL", query);
    expectedId[oraclizeId] = id;
  }
}
