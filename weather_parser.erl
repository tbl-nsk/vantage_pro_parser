-module (weather_parser).

-export ([start/0]).

start () ->
  {ok, [FileNames]} = init:get_argument (file),
%  FileNames = lists:flatten (FileNames1),
  BinList = lists:map (
    fun (X) ->
        {ok, BinData} = file:read_file (X),
        BinData
    end,
    FileNames
  ),
  Binary = list_to_binary (BinList),
  Data = parse (Binary),
  print (Data),
  ok.

parse (Data) ->
  parse ([], Data).

parse (Parsed, <<>>) ->
  lists:reverse (Parsed);
parse (Parsed, BinData) ->
  <<Packet:119/binary, Else/binary>> = BinData,
  parse ([parse_packet (Packet) | Parsed], Else).

parse_packet (Packet) ->
  io:format ("parsing ~w~n", [Packet]),
  <<
  YearBin:4/binary, $.:8,
  MonthBin:2/binary, $.:8,
  DayBin:2/binary, $-:8,
  HourBin:2/binary, $::8,
  MinuteBin:2/binary, $::8,
  SecondsBin:2/binary,
  $-:8, $L:8, $O:8, $O:8,
  BarTrend:8/little-signed-integer,
  0:8,
  NextRecord:16,
  Barometer:16,
  InsideTemp:16,
  InsideHumidity:8,
  OutsideTemp:16,
  WindSpeed:8,
  TenMinAvgWindSpeed:8,
  WindDir:16,
  ExtraTemp1:8,
  ExtraTemp2:8,
  ExtraTemp3:8,
  ExtraTemp4:8,
  ExtraTemp5:8,
  ExtraTemp6:8,
  ExtraTemp7:8,
  SoilTemp1:8,
  SoilTemp2:8,
  SoilTemp3:8,
  SoilTemp4:8,
  LeafTemp1:8,
  LeafTemp2:8,
  LeafTemp3:8,
  LeafTemp4:8,
  OutsideHumidity:8,
  ExtraHumidity1:8,
  ExtraHumidity2:8,
  ExtraHumidity3:8,
  ExtraHumidity4:8,
  ExtraHumidity5:8,
  ExtraHumidity6:8,
  ExtraHumidity7:8,
  RainRate:16,
  UV:8,
  SolarRadiation:16,
  StormRain:16,
  StartMonthOfCurStorm:4,
  StartDayOfCurStorm:5,
  StartYearOfCurStorm:7,
  DayRain:16,
  MonthRain:16,
  YearRain:16,
  DayET:16,
  MonthET:16,
  YearET:16,
  SoilMoisture1:8,
  SoilMoisture2:8,
  SoilMoisture3:8,
  SoilMoisture4:8,
  LeafWetness1:8,
  LeafWetness2:8,
  LeafWetness3:8,
  LeafWetness4:8,
%%%%%%%  InsideAlarms:8,
  InsideFallingBarTrendAlarm:1,
  InsideRisingBarTrendAlarm:1,
  InsideLowTempAlarm:1,
  InsideHighTempAlarm:1,
  InsideLowHumAlarm:1,
  InsideHighHumAlarm:1,
  _:2,
%%%%%%  RainAlarms:8,
  RainHighRateAlarm:1, 
  RainFifteenMinAlarm:1,
  RainDayAlarm:1,
  RainStormTotalAlarm:1,
  RainDailyETAlarm:1,
  _:3,
%%%%%%  OutsideAlarms:16,
  OutsideLowTempAlarm:1,
  OutsideHighTempAlarm:1,
  OutsideWindSpeedAlarm:1,
  OutsideTenMinWindSpeedAlarm:1,
  OutsideLowDewPointAlarm:1,
  OutsideHighDewPointAlarm:1,
  OutsideHighHeatAlarm:1,
  OutsideLowWindChillAlarm:1,
  OutsideHighTHSWAlarm:1,
  OutsideHighSolarRadiationAlarm:1,
  OutsideHighUVAlarm:1,
  OutsideUVDoseAlarm:1,
  OutsideUVDoseAlarmEnabled:1,
  _:3,
  ExtraTempHumAlarms:64,
  SoilLeafAlarms:32,
  TransmitterBatteryStatus:8,
  ConsoleBatteryVoltage:16,
  ForecastIconRain:1,
  ForecastIconCloud:1,
  ForecastIconPartlyCloudy:1,
  ForecastIconSun:1,
  ForecastIconSnow:1,
  _:3,
%  ForecastIcons:8,
  ForecastRuleNumber:8,
  TimeOfSunrise:16,
  TimeOfSunset:16,
  10:8,
  13:8,
  CRC:16,
  Else/binary
  >> = Packet,
  io:format ("else: ~w~n", [Else]),
  Year = bli (YearBin),
  Month = bli (MonthBin),
  Day = bli (DayBin),
  Hour = bli (HourBin),
  Minute = bli (MinuteBin),
  Seconds = bli (SecondsBin),
  Date = lists:flatten (io_lib:format ("~b-~b-~b ~b:~b:~b", [Year, Month, Day, Hour, Minute, Seconds])),
%  erlang:error ("parsed and formated"),
%  io:format ("~s~n", [Date]),
  [
    Date,
    BarTrend,
    NextRecord,
    Barometer,
    f2c (InsideTemp),
    InsideHumidity,
    f2c (OutsideTemp),
    WindSpeed * 1.6,
    TenMinAvgWindSpeed * 1.6,
    WindDir,
    f2c (ExtraTemp1 - 90),
    f2c (ExtraTemp2 - 90),
    f2c (ExtraTemp3 - 90),
    f2c (ExtraTemp4 - 90),
    f2c (ExtraTemp5 - 90),
    f2c (ExtraTemp6 - 90),
    f2c (ExtraTemp7 - 90),
    f2c (SoilTemp1 - 90),
    f2c (SoilTemp2 - 90),
    f2c (SoilTemp3 - 90),
    f2c (SoilTemp4 - 90),
    f2c (LeafTemp1 - 90),
    f2c (LeafTemp2 - 90),
    f2c (LeafTemp3 - 90),
    f2c (LeafTemp4 - 90),
    OutsideHumidity,
    ExtraHumidity1,
    ExtraHumidity2,
    ExtraHumidity3,
    ExtraHumidity4,
    ExtraHumidity5,
    ExtraHumidity6,
    ExtraHumidity7,
    RainRate * 0.2,
    UV,
    SolarRadiation,
    StormRain * 0.2,
    lists:flatten (io_lib:format ("~b-~b-~b", [2000 + StartYearOfCurStorm, StartMonthOfCurStorm, StartDayOfCurStorm])),
    DayRain * 0.2,
    MonthRain * 0.2,
    YearRain * 0.2,
    DayET * 0.2,
    MonthET * 0.2,
    YearET * 0.2,
    SoilMoisture1,
    SoilMoisture2,
    SoilMoisture3,
    SoilMoisture4,
    LeafWetness1 * 100 / 15,
    LeafWetness2 * 100 / 15,
    LeafWetness3 * 100 / 15,
    LeafWetness4 * 100 / 15,
    InsideFallingBarTrendAlarm,
    InsideRisingBarTrendAlarm,
    InsideLowTempAlarm,
    InsideHighTempAlarm,
    InsideLowHumAlarm,
    InsideHighHumAlarm,
    RainHighRateAlarm,
    RainFifteenMinAlarm,
    RainDayAlarm,
    RainStormTotalAlarm,
    RainDailyETAlarm,
    OutsideLowTempAlarm,
    OutsideHighTempAlarm,
    OutsideWindSpeedAlarm,
    OutsideTenMinWindSpeedAlarm,
    OutsideLowDewPointAlarm,
    OutsideHighDewPointAlarm,
    OutsideHighHeatAlarm,
    OutsideLowWindChillAlarm,
    OutsideHighTHSWAlarm,
    OutsideHighSolarRadiationAlarm,
    OutsideHighUVAlarm,
    OutsideUVDoseAlarm,
    OutsideUVDoseAlarmEnabled,
    ExtraTempHumAlarms,
    SoilLeafAlarms,
    TransmitterBatteryStatus,
    ConsoleBatteryVoltage,
    ForecastIconRain,
    ForecastIconCloud,
    ForecastIconPartlyCloudy,
    ForecastIconSun,
    ForecastIconSnow,
    ForecastRuleNumber,
    hourmin (TimeOfSunrise),
    hourmin (TimeOfSunset)
  ].

bli (I) ->
  list_to_integer (binary_to_list (I)).

print ([]) ->
  ok;
print ([L | T]) ->
  print_line (L),
  print (T).

print_line ([]) ->
  io:format ("~n");
print_line ([H | T]) ->
  print_elem (H),
  print_line (T).

print_elem (E) when is_list (E) ->
  io:format ("'~s';", [E]);
print_elem (E) when is_integer (E) ->
  io:format ("~B;", [E]);
print_elem (E) when is_float (E) ->
  io:format ("~f;", [E]).

f2c (TempF) ->
  (TempF - 32) * 5/9.

hourmin (T) ->
  Hour = T div 100,
  Min = T rem 3,
  lists:flatten (io_lib:format ("~b:~b:00", [Hour, Min])).
