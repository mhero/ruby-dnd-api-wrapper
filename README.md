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




