# Import tester and utils. Initiate block.
import serpent
import ethereum.tester as t
import ethereum.utils as u
s = t.state()

# Setup test keys and addresses.
key1 = u.sha3("this is an insecure passphrase")
addr1 = u.privtoaddr(key1)

# Write contract and commit to blockchain.
serpent_code='''
def multiply(a):
  return(a*2)
'''
c = s.abi_contract(serpent_code, sender=key1)

o = c.multiply(5)
print(str(o))
