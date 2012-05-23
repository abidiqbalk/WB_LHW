# LHW - Rails Dashboard for Directorate of Staff Development.

The **LHW Dashboard** is an application aiming to provide basic reporting intelligence on top of the google ODK based collection system for DSD.

## Installation

Assuming you have Rails 3.2, Ruby 1.9.3 (with devkit if your on windows) and MySQL setup:

  1. Import the MYSQL Dump file to load the meta-data into lhw_development or whatever you have defined in /config/database.yml.
  2. Create Yetting.yml (see the sample file) in your /config folder and enter the Google Fusion Table account name and password given to you. 

Run the following command to install dependencies:

`bundle install`

And start the server!

`Rails s`

## Application Overview

Please refer to the [wiki](https://github.com/AhmerArif/WB_DSD/wiki) for details

[Detailed Documentation](http://rubydoc.info/github/AhmerArif/WB_DSD/master/frames) is also available online

## Information

### Issue Tracker

If you have any questions, comments, or concerns please use the GitHub Issues tracker

### Bug reports

If you discover any bugs, feel free to create an issue on GitHub. Please add as much information as
possible to help us fixing the possible bug. We also encourage you to help even more by forking and
sending us a pull request.

## Maintainers

* [Ahmer Arif](https://github.com/AhmerArif)

## License

MIT License. Copyright 2012 World Bank.