## LoyaltyPlus code challenge


### Setup

1. Initialize database (uses SQLite):
- `rake db:create`
- `rake db:migrate`
2. Run the tests: `rspec`
___


### The way it works: Models and Relationships
```
User has_many Purchases
User has_many PointLedgerEntries through Purchases

# User#point_ledger_entries lists all point ledger entries for au ser
# User#purchases lists all purchases for a user

Purchase belongs_to User
Purchase has_many PointLedgerEntries

# Purchase#point_ledger_entries lists all point ledger entries for a purchase
# Purchase#user returns the associated user for a purchase

PointLedgerEntry belongs_to Purchase
PointLedgerEntry has_one User through Purchase

# PointLedgerEntry#purchase returns the associated purchase
# PointLedgerEntry#user returns the associated user
```
___


### The way it works: Service Objects
_`CreatePurchase` is responsible for creating a purchase for a certain amount and crediting that same amount of points to the point ledger associated to the newly created purchase._

Use:
```
user = User.create email: 'email@email.com', account_id: 'abcd'
CreatePurchase.new(user, 100).call 

# This will create a purchase for 100 dollars and credit 100 points to the associated ledger.
```

_`RedeemPoints` is responsible for redeeming points in a first-in / first-out order from the current user's point ledger. Points cannot be redeemed unless the user has at least 100 points. Points can also not be redeemed if the requested amount exceeds the point balance of the current user._

User:
```
user = User.create email: 'email@email.com', account_id: 'abcd'
RedeemPoints.new(user, 100).call

# This will redeem 100 points from the associated point ledger, leaving the balance at 0.
```

_Both service objects return the new balance after the transaction_
___

### Scope and Expectations
 _Run the following commands in `rails console`, in sequential order._


##### 1. Enroll a Frontier Rewards member by email address and account_id

_Let's create a user to use for the rest of the examples_
```ruby
user = User.create email: 'sam@email.com', account_id: 'aabacd'
```

##### 2. Record Frontier Rewards member purchase activity and add to the points ledger by email address and account_id

_Let's add 50 points to the ledger for the user account we just created_
```ruby
CreatePurchase.new(user, 50).call
```

##### 3. Can check the point balance of a member by email address and account_id

_Let's check the point balance, it should be 50._
```ruby
user.points_balance
```

##### 4. Redeem points for a reward, if the member is eligible, by email address and account_id

_Let's try to redeem 50 points, you should receive an error_
```ruby
RedeemPoints.new(user, 50).call
```

_Let's add another purchase and try again_
```ruby
CreatePurchase.new(user, 150).call
RedeemPoints.new(user,100).call
```

_Now, let's try to redeem more points than we have. You should receive an error._
```ruby
RedeemPoints.new(user, 101).call
```

##### 5. At the end of each method call, print out the ending balance of the member

_The new balance is printed at the end of each method call that modifies the ledger_
```ruby
CreatePurchase.new(user, 1000).call
RedeemPoints.new(user, 100).call
```

##### 6. Transactions must be redeemed in first-in / first-out order

_Let's take a look at the ledger for our first purchase. This shows us where all the points for this purchase have gone._
```ruby
user.purchases.first.point_ledger_entries
```

_Now, let's compare how many points remain from this purchase to how many were originally earned for this purchase._
```ruby
user.purchases.first.points_remaining
user.purchases.first.points_earned
```

_Now, let's demonstrate points being debited across multiple purchases. We have 1000 points remaining, all from our last purchase. So, let's create another purchase for 500 dollars and redeem 1200 points. 1000 should come from the previous purchase and 200 should come from our newest purchase._
```ruby
CreatePurchase.new(user, 500).call
RedeemPoints.new(user, 1200).call

# Now, let's check the ledgers for the two purchases.
user.purchases[2].point_ledger_entries
user.purchases.last.point_ledger_entries

# You can see that 1000 points were taken from the previous purchase and 200 points were taken from our most recent purchase
```
___

##### That's it! :) 
##### Please let me know if you have any questions: jaredplanter@gmail.com

#### To restart this example, run: `User.destroy_all`
