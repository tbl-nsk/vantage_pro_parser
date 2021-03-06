drop sequence weather.zseq_vantage_pro_loop_data;
create sequence weather.zseq_vantage_pro_loop_data
  increment by 1
  no minvalue
  no maxvalue
  cache 1
  start 1;

drop table weather.vantage_pro_loop_data;
create table weather.vantage_pro_loop_data (
  id bigint,
  eventtime timestamp with time zone not null,
  bar_trend bigint not null,
  bar float not null,
  temp_inside float not null,
  humidity_inside float not null,
  temp_outside float not null,
  wind_speed float not null,
  wind_speed_ten_min_avg float not null,
  wind_direction float not null,
  temp_extra1 float not null,
  temp_extra2 float not null,
  temp_extra3 float not null,
  temp_extra4 float not null,
  temp_extra5 float not null,
  temp_extra6 float not null,
  temp_extra7 float not null,
  temp_soil1 float not null,
  temp_soil2 float not null,
  temp_soil3 float not null,
  temp_soil4 float not null,
  temp_leaf1 float not null,
  temp_leaf2 float not null,
  temp_leaf3 float not null,
  temp_leaf4 float not null,
  humidity_outside float not null,
  humidity_extra1 float not null,
  humidity_extra2 float not null,
  humidity_extra3 float not null,
  humidity_extra4 float not null,
  humidity_extra5 float not null,
  humidity_extra6 float not null,
  humidity_extra7 float not null,
  rain_hour_rate float not null,
  uv float not null,
  solar_radiation float not null,
  storm_rain float not null,
  start_rain_date date not null,
  rain_day_rate float not null,
  rain_month_rate float not null,
  rain_year_rate float not null,
  et_day float not null,
  et_month float not null,
  et_year float not null,
  moisture_soil1 float not null,
  moisture_soil2 float not null,
  moisture_soil3 float not null,
  moisture_soil4 float not null,
  wetness_leaf1 float not null,
  wetness_leaf2 float not null,
  wetness_leaf3 float not null,
  wetness_leaf4 float not null,
  alarm_inside_falling_bar_trend boolean not null,
  alarm_inside_rising_bar_trend boolean not null,
  alarm_inside_low_temp boolean not null,
  alarm_inside_high_temp boolean not null,
  alarm_inside_low_humidity boolean not null,
  alarm_inside_high_humidity boolean not null,
  alarm_rain_high_rate boolean not null,
  alarm_rain_fifteen_minutes boolean not null,
  alarm_rain_day_alarm boolean not null,
  alarm_rain_storm_total boolean not null,
  alarm_rain_daily_et boolean not null,
  alarm_outside_low_temp boolean not null,
  alarm_outside_high_temp boolean not null,
  alarm_outside_wind_speed boolean not null,
  alarm_outside_wind_ten_minutes boolean not null,
  alarm_outside_dew_point_low boolean not null,
  alarm_outside_dew_point_high boolean not null,
  alarm_outside_high_heat boolean not null,
  alarm_outside_low_wind_chill boolean not null,
  alarm_outside_high_thsw boolean not null,
  alarm_outside_high_solar_radiation boolean not null,
  alarm_outside_high_uva boolean not null,
  alarm_outside_uv_dose boolean not null,
  alarm_outside_uv_dose_enabled boolean not null,
  alarms_extra_temp_humidity bigint not null,
  alarms_soil_leaf bigint not null,
  transmitter_battery_status bigint not null,
  cosole_battery_voltage bigint not null,
  forecast_icon_rain boolean not null,
  forecast_icon_cloud boolean not null,
  forecast_icon_partly_cloudy boolean not null,
  forecast_icon_sun boolean not null,
  forecast_icon_snow boolean not null,
  forecast_rule_number bigint not null,
  time_sunrise time without time zone not null,
  time_sunset time without time zone not null,

  constraint zidx_vantage_pro_loop_data_pk_id primary key (id),
  constraint zidx_vantage_pro_loop_data_uk_eventtime unique (eventtime)
);

create index zidx_vantage_pro_loop_data_ik_eventtime on weather.vantage_pro_loop_data (eventtime);
