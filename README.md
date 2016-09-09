## Introduction

A New Relic agent to collect status information from phusion passenger via the xml output of the passenger-status command

NOTE!!! Currently supports Passenger 5, parsing may not work correctly with passenger 3 outputs but should still work with Passenger 4

## Passenger Agent Installation

1. Download the latest version
2. Extract to the location you want to run the agent from
3. `bundle install` to get the necessary gems
4. Copy `config/template_newrelic_plugin.yml` to `config/newrelic_plugin.yml`
5. Edit `config/newrelic_plugin.yml` and replace "YOUR_LICENSE_KEY_HERE" with your New Relic license key
6. Edit `config/newrelic_plugin.yml` and add the full path to your 'passenger-status --show=xml' command if needed, as well as the hostname (as you want it to appear in NewRelic)
7. Run `./newrelic_passenger_agent`

## Data Collected

Data for this agent is collected by running the commands 'passenger-status --show=xml' then parsing the results

Data captured for => passenger-status --show=xml
- no. of processes running (max and current)
- no. waiting in global queue
- no. waiting in per-PID queue
- sessions active per-PID
- cpu usage per-PID
- memory usage per-PID
- uptime in seconds per-PID
- last-processed time per-PID

## Other Sources

This agent originally based on the passenger agent by tamaloa https://github.com/tamaloa/newrelic_passenger_plugin
