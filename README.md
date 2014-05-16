dvr-scheduler
=============

A client is asking you to build software for their new DVR device. 

Input to the system will be: 
* Date 
* Timespan
* Channel   

At minimum, your system needs to provide an interface for the DVR system that allows users to enter schedules, and also allows the recording equipment to query what channel it should be recording at a certain time.
  

## Get Recordings

The system should be able to retreive recordings.
* Get all recordings
* Get recordings by UUID
* Get recordings by Channel
* Get recordings by a datetime

A recordings should look as follows:
* UUID
* Timestamp
* Channel
* Start Time
* End Time

## Add Recordings

The system should be able to add recordings
* Start Time
* End Time
* Channel

## Delete Recordings

The system should be able to delete recordings
* Delete by UUID
* Delete by channel
* Delete by datetime
* Delete by span of time

## Perl Modules

Dvr::Database is mock database interaction currently. In session, this will hold and retreive values for the program. Should eventually connect to a DB or at lease write to disk.

Dvr::Validator is a collection of methods to validate input, just good to keep this someplace else as it usually looks messy and doesn't need to be in the in the Scheduler code.

Dvr::Scheduler will be the API into the DVR, a collection of methods to retreive or change recording data.
