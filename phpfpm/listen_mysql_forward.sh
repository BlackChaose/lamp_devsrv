#!/bin/bash

socat TCP-LISTEN:3306,fork TCP:mysql:3306
