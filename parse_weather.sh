#!/bin/sh

WEATHER_DATA_PATH='data'

erl -file $WEATHER_DATA_PATH/* -s weather_parser start -noshell |
  sed 's/^\(.*\),$/insert into weather.vantage_pro_loop_data values (\1);/g' |
  psql -U weather AutoGis2 |
  grep -v 'INSERT 0 1'
