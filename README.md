# knife-lastrun

A plugin for Chef::Knife which displays node metadata about the last chef run.

## Usage 

Supply a node name to get metrics from the last chef run

```
% knife node lastrun jgoulah.vm.mydomain.com
Status                     success
Elapsed Time               74.198614
Start Time                 2012-02-22 00:39:04 +0000
End Time                   2012-02-22 00:40:18 +0000

Recipe                        Action                        Resource Type                 Resource
bigdata::default              run                           bash                          check for bashrc

Backtrace            none
Exception            none
Formatted Exception  none
```

## Installation

#### Gem install

knife-lastrun is available on rubygems.org - if you have that source in your gemrc, you can simply use:

    gem install knife-lastrun

#### Configure the Handler

in /etc/chef/client.rb

```
require "lastrun_update"
handler = LastRunUpdateHandler.new
report_handlers    << handler
exception_handlers << handler 
```
