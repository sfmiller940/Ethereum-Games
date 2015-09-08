# Import tester and utils. Initiate block.
import ethereum.tester as t
import ethereum.utils as u
s = t.state()

# Setup test keys and addresses.
key1 = u.sha3("this is an insecure passphrase")
addr1 = u.privtoaddr(key1)
key2 = u.sha3("37Dhsg17e92dfghKa Th!s i$ mUcH better r920167dfghjiHFGJsbcm")
addr2 = u.privtoaddr(key2)

# Check balances
print s.block.get_balance(addr1)
print s.block.get_balance(addr2)

# Set new address as coinbase and mine some coin.
s.block.coinbase = addr1
s.mine(n=10)

# Check balances
print s.block.get_balance(addr1)
print s.block.get_balance(addr2)

# Send 1000 wei from key1 to addr2.
s.send(key1, addr2, 1000)

# Check balances
print s.block.get_balance(addr1)
print s.block.get_balance(addr2)
