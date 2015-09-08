// Import tester and utils. Initiate block.
import ethereum.tester as t
import ethereum.utils as u
s = t.state()

// Setup test keys and addresses.
key1 = utils.sha3("this is an insecure passphrase")
addr1 = utils.privtoaddr(key1)
key2 = utils.sha3("37Dhsg17e92dfghKa Th!s i$ mUcH better r920167dfghjiHFGJsbcm")
addr2 = utils.privtoaddr(key2)

// Set new address as coinbase and mine some coin.
s.block.coinbase = addr1
s.mine(n=10)

// Send 1000 wei from key1 to addr2.
s.send(key1, addr2, 1000)
