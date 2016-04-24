# Hunters Nework
#### Find the top Product Hunters in your Twitter network

## Motivation
When launching a new product on Product Hunt, planning is 🔑 for a successful launch. 
One of the most important steps here is to find an influential Hunter to post your product on PH. Furthermore, it's important to gather and contact a large group of active users on PH to upvote, comment and share your product as well.

## Configuration
To make calls to both Twitter and Product Hunt APIs you are required to register two applications.

1. [Register a Twitter application](https://apps.twitter.com/) 
2. [Register a Product Hunt application](https://www.producthunt.com/v1/oauth/applications) 
3. Rename the file `config.yml.template` to `config.yml` and fill in with the API Keys and Access Tokens you just generated

## Usage

    $ ruby main.rb [-v] [-u <username>]

Examples:
To find out who are the Hunters in *your* Twitter network

    $ ruby main.rb

To find out who are the Hunters in another user's Twitter network (e.g. twitter.com/ProductHunt)

    $ ruby main.rb -v -u ProductHunt

## Result
The result is a CSV file with the list of your Twitter friends that also have an active account on Product Hunt, ordered by the number of followers they have on PH (more influential).

## Improvements & Suggestions
- Handle API rate limits
- Find an alternative strategy to match Twitter users with ProductHunt users (here I'm assuming everyone uses the same username for Twitter and ProductHunt, which is correct in 95% of the cases)

If you feel this script could be improved or if you have any suggestions, open an issue, make a PR or holla at me. 

With love, 
[@brunohq](http://twitter.com/brunohq)
