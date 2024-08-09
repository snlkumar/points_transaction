# README

Ruby version: '3.2.5'
Rails version: '7.1.3.4'

Steps to setup the code on local
* Make sure required ruby and rails version installed on local machine
* clone the repo
* bundle install
* bundle exec rake db:create and rake db:migrate
* run the server: rails server

Run the spec
```
bundle exec rspec spec

```

```
CURL to store single transaction

curl --location --request POST 'http://localhost:3000/api/v1/transactions/single' \
--header 'Content-Type: application/json' \
--header 'Cookie: _d=No8ZwvylOnaieeX99D71UQ' \
--data-raw '{
    "transaction_id": "uid-123",
    "points": 10,
    "user_id": 23
}'

```
Bulk transaction

```
curl --location --request POST 'http://localhost:3000/api/v1/transactions/bulk' \
--header 'Content-Type: application/json' \
--header 'Cookie: _d=No8ZwvylOnaieeX99D71UQ' \
--data-raw '{
    "transactions": [
        {
            "transaction_id": "bulk-123",
            "points": 345,
            "user_id": "223"
        },
        {
            "transaction_id": "bulk-124",
            "points": 347,
            "user_id": "224"
        },
        {
            "transaction_id": "bulk-125",
            "points": 356,
            "user_id": "226"
        },
        {
            "transaction_id": "bulk-127",
            "points": 358,
            "user_id": "229"
        }
    ]
}'

```
CI/CD: CI has been configured with github actions
Following checks have been added.
1. test cases must be passed
2. Security audit of gems.
3. Security audit of application code.
4. Rubocop

Note: 
I have not added any model level validations and association because it was not mentioned in the assingment. 
I am processing bulk transaction inline but i would prefer using background process. I have not implemented backgroud job because it was not mentioned in the assignment and the response message would be different.

