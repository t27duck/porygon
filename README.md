## This Readme is a work in progress

### What is this?

This is the source code for the GoNintendo.com IRC bot named "porygon" written in Ruby.

Based heavily off of http://dzone.com/snippets/simple-irc-bot-written-ruby

### What does it do?

* Pokedex information (%dexter 25, %dexter Pikachu) from a database
* Twitter tweet output (Parses a URL of a tweet)
* Logging of the room
* GoNintendo.com story output (Parses the URL of a story and outputs the story title)
* Notification of a new top story or the activation of the live feed player
* Random/funny text output based on specific input

### Bootstrapping

* Copy and edit config.yml.example to config.yml
* Run bundle
* Run ````bundle exec ruby main.rb````
* Tested on Ruby 1.9.3 and 2.0
