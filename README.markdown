Derring-Do
==========

Derring-Do is a silly progress monitor that you can add to your console
Ruby applications.

It will emit "encouraging" words periodically, to indicate progress is being
made on a job. If the campaign (or job) is given a target, the progress
will also include updates saying specifically how far the campaign has gone
toward that target.

Usage
-----

  require 'derring-do'

  # untargetted campaigns (with no specifical goal in mind)

  derring do |campaign|
    1000.times do
      campaign.tally_ho!
      sleep 0.2
    end
  end

  # targetted campaigns (aiming for a particular goal)

  derring do |campaign|
    campaign.target = 2000
    1000.times do
      campaign.tally_ho! 2
      sleep 0.2
    end
  end

Installation
------------

  gem install derring-do

Caveats
-------

I wrote this mostly to teach myself how to use rspec. The idea occurred to me
while mostly asleep, so while it may not be actually useful, it is certainly
whimsical.

License
-------

This library is placed in the public domain by the author, Jamis Buck. Do
with it what you will. Please prefer good over evil.
