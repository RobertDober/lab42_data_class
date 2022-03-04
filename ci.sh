#!/usr/bin/env bash

bundle exec rubocop && bundle exec speculate && bundle exec rspec
