dvr-scheduler
=============

A simple DVR recording scheduler that will allow you to query for, add, and replace recordings.

To run the DVR scheduler:
* Clone dvr-scheduler: *git clone https://github.com/nvts8a/dvr-scheduler.git*
* Move into the dvr-scheduler directory: *cd dvr-scheduler/*
* Run the Perl program with the libraries directory included in @INC: *perl -I ./lib/ bin/Dvr.pl*
* Run the DVR scheduler tests run: *perl -I ./lib/ tests/SmokeTest.pl*


## Files and Directories 

* **bin/Dvr.pl** - The main application to run. Code here prints menus, takes user input, routes and calls Dvr::Scheduler and is independant from the DVR Schduler API.
* **lib/Dvr/** - This directory holds the modules found in the section titled "Perl Modules." This is the code and libraries written for the DVR Schduler API.
* **data/recordings.csv** - This is the CSV Dvr::Database reads and writes to. At anytime you could open this to manually inspect the current data.
* **tests/** - This directory contains the generic SmokeTest.pl, a cookie cutter perl application that will run all of its \*.t file siblings. 
 

## Perl Modules

**Dvr::Database** is the module for writing to and querying against a CSV file on disk. Was not suppose to contain as much business logic as it does, but built in a way that I could remove the business logic for a conf file or find/create file methods. 

**Dvr::Validator** is a collection of methods to validate input, just good to keep this someplace else as it usually looks messy and doesn't need to be in the in the Scheduler code.

**Dvr::Scheduler** will be the API into the DVR, a collection of methods to retreive or change recording data. Any application being built that can hit these methods can work as a DVR scheduler.

**Data::Uniqid** is a CPAN module being used to create the Database unique ID.

## Get Recordings

The system should be able to retreive recordings.
* Get all recordings
* Get recordings by UUID
* Get recordings by Channel
* Get recordings by a datetime

A recording should look as follows when stored:
* UUID: 
* Timestamp
* Channel
* Start Time
* End Time

Example:
**1HJdTq7mGK,2014-05-19 00:15:20,123,2015-03-15 03:30:00,2015-03-15 04:00:00,**

## Add Recordings

The system should be able to add recordings using the following inputs:
* Start datetime 
* Span of time in minutes
* Channel

## Delete Recordings

bin/Dvr.pl does not have the functionality to DELETE recordings while Dvr::Scheduler does. But what Dvr.pl does if there is another recording at the same time it will ask you if you want to replace it. Which will delete the current recording and attempt to re-add the new recording.

The system should be able to delete recordings
* Delete by UUID - **The API can only delete by UUID currently, bin/Dvr.pl contains the logic that will get the UUID and delete by UUID.**

