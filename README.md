# WARNING!

This repo is offically deprecated. Use at your own risk.

# Source Code

The code that runs the DigitalGov Search [Non-.gov URLs API](http://search.digitalgov.gov/developer/govt-urls.html)&mdash;a list of government URLs that don't end in .gov or .mil.&mdash;is here on Github. If you're a Ruby developer, keep reading. Fork this repo to add features (such as additional datasets) or fix bugs.

The documentation on request parameters and response format is on the [API developer page](http://search.digitalgov.gov/developer/govt-urls.html). This README just covers software development of the API service itself.

# Data Source

We maintain this list at <http://govt-urls.usa.gov/tematres/vocab/index.php> and make periodic updates as we come across changes.

Each quarter, we also post the URLs here in Github in two text files.

1. [Alphabetic](/government-urls-alphabetic-list.txt)&mdash;an A-Z list of URLs with accompanying notes and relationships collected over time.
2. [Hierarchical](/government-urls-hierarchical-list.txt)&mdash;a flat list of URLs segmented by category (see BT description in the following section).

Cross reference symbols that you'll find in the alphabetic list include:

* **BT (broader term)**&mdash;indicates the category for each URL, such as federal (usagovFED) or state, commonwealth, or territory (usagov__, 2-letter [postal abbreviation](https://www.usps.com/send/official-abbreviations.htm)).
* **NT (narrower term)**&mdash;the opposite of BT. 
* **UF (used for)**&mdash;indicates the nonpreferred URL. Nonpreferred URLs no longer resolve or redirect to another URL. UF is the reciprocal of USE and means "don't use" the term following it.
* **USE**&mdash;indicates the preferred, resolving URL. "Use" the term following it.
* **RTET (related equivalent term)**&mdash;indciates two URLs that both resolve to the same website. Neither is preferred. 
* **RT (related term)**&mdash;indicates an association between two related terms when it seems helpful.

# Running the API Locally

## Ruby

The project requires [Ruby 2.2.2](https://www.ruby-lang.org/en/downloads/).

## Gems

We use bundler to manage gems. You can install bundler and other required gems like this:

    gem install bundler
    bundle install

## Elasticsearch

We're using [Elasticsearch](http://www.elasticsearch.org/) (>= 1.2.0) for fulltext search. On a Mac, it's easy to install with [Homebrew](http://mxcl.github.com/homebrew/).

    brew install elasticsearch

Otherwise, follow the [instructions](http://www.elasticsearch.org/download/) to download and run it.  Elasticsearch must be running locally.

## Redis

You'll need to have redis installed on your machine. `brew install redis`, `apt-get install redis-server`, etc.  Redis must also be running locally and can be started with the `redis-server` command.

## Starting the Server

	bundle exec rails s

## Starting Sidekiq

Sidekiq must be running to import the data into Elasticsearch.

	bundle exec sidekiq

## Importing the Data

	bundle exec rake tematres:import

## Viewing the Results

Navigate to [http://localhost:3000/government_urls/search?](http://localhost:3000/government_urls/search?).

## Contributing

We welcome comments and additions. [Submit a new issue](https://github.com/GSA/govt-urls/issues) to contribute directly to this list or email us at <search@support.digitalgov.gov>.
