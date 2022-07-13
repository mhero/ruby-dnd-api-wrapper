## Full install

1. Install dependencies

```
\curl -sSL https://get.rvm.io | bash
rvm install "ruby-3.1.2"
rvm use 3.1.2
```

2. Clone repository
3. `cd` into repository folder

4. Install gems

```
gem install bundler
bundle install
```

5. First run(configure database and download data)
```
ruby lib/app.rb -n 
ruby lib/app.rb -d
```

6. Run, result will show only 10 results
```
ruby lib/app.rb -g set
ruby lib/app.rb -g set,rarity
ruby lib/app.rb -c red,blue
ruby lib/app.rb -x red,blue
ruby lib/app.rb -s KTK -c red,blue
```

7. See more results(i.e. will show page 2)

```
ruby lib/app.rb -g set -p 2
ruby lib/app.rb -g set,rarity -p 2
ruby lib/app.rb -c red,blue -p 2
ruby lib/app.rb -x red,blue -p 2
ruby lib/app.rb -s KTK -c red,blue -p 2
```

8. See help(optional)

```
 ruby lib/app.rb -h
```

# Approach
 - I started reading the API and how it worked trying to understand how to use it.
 - Since there was a lot of data involved, I decided to use the API to get the data and then store it to be used by the app.
 - I satrted using a simple `HttpClient`with `Faraday`. I decided to use this because I used it before and it's very reliable and easy to use.
 - I created a mutli-threaded scraper(`CardFetcher`) to get the data from the API and store it in a database. This class also has an array working as kind of DLQ to store the pages that for some reason failed to be fetched.
 - Since the data was huge and made of different fields I decided not to manage it in memory. Instead I'm using a database which would not need any extra installation. I choose `SQLite3` becasue of the aforementioned reasons. Since I knew the scope of the problem and the structure of the data and also the capabilities of the database, I choose to manage all the data in a one simplified table(model).
 - For handling the data I used `Sequel` because I wanted to keep a simple queryable structure(not manage other tables consistency for now). Also it includes a pagination capability.
 - I'm using a custom filter(`Filter`) to manage the queries for the model(manage `ìn` and `like` queries). And extending this logic in the `Card` model.
 - Finally I handle the command line execution using `OptionParser` so it can be called directly as a command line tool.

 I had fun working on it!. I hope you enjoy it!
# Backend coding exercise

For this coding exercise you will use the public API provided by https://magicthegathering.io to build a command line tool that can query and filter Magic The Gathering cards.

## The exercise

Using **only** the https://api.magicthegathering.io/v1/cards endpoint and **without using any query parameters for filtering**, create a command-line tool that can be used by one of our engineers to query, filter, and group cards. Ensure that your tool can be used to return the following example lists:

* A list of **Cards** grouped by **`set`**.
* A list of **Cards** grouped by **`set`** and within each **`set`** grouped by **`rarity`**.
* A list of cards from the  **Khans of Tarkir (KTK)** set that ONLY have the colours `red` **AND** `blue`

Once you've finished coding, spend some time adding a section to this README explaining how you approached the problem: initial analysis, technical choices, trade-offs, etc.

## Environment

* You can use any one of the following programming languages: Ruby, Elixir, JavaScript, Crystal, Python, Go. We want to see you at your best, so use the language you're most comfortable with.
* If you introduce any dependencies outside of your programming language's standard library, document why you added them in this README.

## Limitations

* You are **not** allowed to use a third-party library that wraps the MTG API.
* You can only use the https://api.magicthegathering.io/v1/cards endpoint for fetching all the cards. You **can't use query parameters** to filter the cards.

## What we look for

* Organise your code with low coupling and high cohesion.
* Avoid unnecessary abstractions. Make it readable, not vague.
* Name things well. We know _naming things_ is one of the two hardest problems in programming, so try to not make your solution too cryptic or too clever. Avoid the use of [weasel words](https://gist.github.com/tmcw/35849b7e9b86bb0c125972b2bb275bc7).
* Adhere to your language/framework conventions. No need to get _too_ creative.
* Take a pragmatic approach to testing. Just make sure the basics are covered.
* Take your time. We set no time limit, so simply let us know roughly how much time you spent. By our estimate, it should take roughly 4 hours. It's not an issue if you go over this but PLEASE do not spend more than 6 hours on it.
