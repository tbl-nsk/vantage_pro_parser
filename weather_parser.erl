-module (weather_parser).

-export ([start/0, main/1]).

-define (BYTE, 1/little-unsigned-integer-unit:8).
-define (WORD, 1/little-unsigned-integer-unit:16).

start () ->
  {ok, [FileNames]} = init:get_argument (file),
  main (FileNames).

main (FileNames) ->
  lists:map (
    fun (X) ->
        {ok, BinData} = file:read_file (X),
        Data = parse (BinData),
        print (Data),
        file:delete (X)
    end,
    FileNames
  ),
  halt (0).

parse (Data) ->
  parse ([], Data).

parse (Parsed, <<>>) ->
  lists:reverse (Parsed);
parse (Parsed, BinData) ->
  <<Packet:119/binary, Else/binary>> = BinData,
  parse ([parse_packet (Packet) | Parsed], Else).

parse_packet (Packet) ->
  <<
  YearBin:4/binary, $.:8,
  MonthBin:2/binary, $.:8,
  DayBin:2/binary, $-:8,
  HourBin:2/binary, $::8,
  MinuteBin:2/binary, $::8,
  SecondsBin:2/binary,
  $-:8, $L:8, $O:8, $O:8,
  BarTrend:?BYTE,
  0:8,
  NextRecord:?WORD,
  Barometer:?WORD,
  InsideTemp:?WORD,
  InsideHumidity:?BYTE,
  OutsideTemp:?WORD,
  WindSpeed:?BYTE,
  TenMinAvgWindSpeed:?BYTE,
  WindDir:?WORD,
  ExtraTemp1:?BYTE,
  ExtraTemp2:?BYTE,
  ExtraTemp3:?BYTE,
  ExtraTemp4:?BYTE,
  ExtraTemp5:?BYTE,
  ExtraTemp6:?BYTE,
  ExtraTemp7:?BYTE,
  SoilTemp1:?BYTE,
  SoilTemp2:?BYTE,
  SoilTemp3:?BYTE,
  SoilTemp4:?BYTE,
  LeafTemp1:?BYTE,
  LeafTemp2:?BYTE,
  LeafTemp3:?BYTE,
  LeafTemp4:?BYTE,
  OutsideHumidity:?BYTE,
  ExtraHumidity1:?BYTE,
  ExtraHumidity2:?BYTE,
  ExtraHumidity3:?BYTE,
  ExtraHumidity4:?BYTE,
  ExtraHumidity5:?BYTE,
  ExtraHumidity6:?BYTE,
  ExtraHumidity7:?BYTE,
  RainRate:?WORD,
  UV:?BYTE,
  SolarRadiation:?WORD,
  StormRain:?WORD,
%  StartYearOfCurStorm:7,
%  StartDayOfCurStorm:5,
%  StartMonthOfCurStorm:4,
  _StartMonthOfCurStorm:4,
  _StartDayOfCurStorm:5,
  _StartYearOfCurStorm:7,
  DayRain:?WORD,
  MonthRain:?WORD,
  YearRain:?WORD,
  DayET:?WORD,
  MonthET:?WORD,
  YearET:?WORD,
  SoilMoisture1:?BYTE,
  SoilMoisture2:?BYTE,
  SoilMoisture3:?BYTE,
  SoilMoisture4:?BYTE,
  LeafWetness1:?BYTE,
  LeafWetness2:?BYTE,
  LeafWetness3:?BYTE,
  LeafWetness4:?BYTE,
%%%%%%%  InsideAlarms:?BYTE,
  InsideFallingBarTrendAlarm:1,
  InsideRisingBarTrendAlarm:1,
  InsideLowTempAlarm:1,
  InsideHighTempAlarm:1,
  InsideLowHumAlarm:1,
  InsideHighHumAlarm:1,
  _:2,
%%%%%%  RainAlarms:?BYTE,
  RainHighRateAlarm:1, 
  RainFifteenMinAlarm:1,
  RainDayAlarm:1,
  RainStormTotalAlarm:1,
  RainDailyETAlarm:1,
  _:3,
%%%%%%  OutsideAlarms:?WORD,
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
  TransmitterBatteryStatus:?BYTE,
  ConsoleBatteryVoltage:?WORD,
  ForecastIconRain:1,
  ForecastIconCloud:1,
  ForecastIconPartlyCloudy:1,
  ForecastIconSun:1,
  ForecastIconSnow:1,
  _:3,
%  ForecastIcons:?BYTE,
  ForecastRuleNumber:?BYTE,
  TimeOfSunrise:?WORD,
  TimeOfSunset:?WORD,
  10:?BYTE,
  13:?BYTE,
  _CRC:?WORD,
  _Else/binary
  >> = Packet,
  Year = bli (YearBin),
  Month = bli (MonthBin),
  Day = bli (DayBin),
  Hour = bli (HourBin),
  Minute = bli (MinuteBin),
  Seconds = bli (SecondsBin),
  Date = lists:flatten (io_lib:format ("~b-~b-~b ~b:~b:~b +7", [Year, Month, Day, Hour, Minute, Seconds])),
%  erlang:error ("parsed and formated"),
%  io:format ("~s~n", [Date]),
  [
    NextRecord,
    Date,
    BarTrend,
    in2mm (Barometer / 1000.0),
    f2c (InsideTemp / 10),
    InsideHumidity,
    f2c (OutsideTemp / 10),
    mph2mps (WindSpeed),
    mph2mps (TenMinAvgWindSpeed),
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
    in2mm (RainRate / 100),
    UV,
    SolarRadiation,
    StormRain * 0.2,
    "1970-1-1 0:0:0",
%    lists:flatten (io_lib:format ("~b-~b-~b", [2000 + StartYearOfCurStorm, StartMonthOfCurStorm, StartDayOfCurStorm])),
    in2mm (DayRain / 100),
    in2mm (MonthRain / 100),
    in2mm (YearRain / 100),
    in2mm (DayET / 100),
    in2mm (MonthET / 100),
    in2mm (YearET / 100),
    SoilMoisture1,
    SoilMoisture2,
    SoilMoisture3,
    SoilMoisture4,
    LeafWetness1 * 100 / 15,
    LeafWetness2 * 100 / 15,
    LeafWetness3 * 100 / 15,
    LeafWetness4 * 100 / 15,
    int2bool (InsideFallingBarTrendAlarm),
    int2bool (InsideRisingBarTrendAlarm),
    int2bool (InsideLowTempAlarm),
    int2bool (InsideHighTempAlarm),
    int2bool (InsideLowHumAlarm),
    int2bool (InsideHighHumAlarm),
    int2bool (RainHighRateAlarm),
    int2bool (RainFifteenMinAlarm),
    int2bool (RainDayAlarm),
    int2bool (RainStormTotalAlarm),
    int2bool (RainDailyETAlarm),
    int2bool (OutsideLowTempAlarm),
    int2bool (OutsideHighTempAlarm),
    int2bool (OutsideWindSpeedAlarm),
    int2bool (OutsideTenMinWindSpeedAlarm),
    int2bool (OutsideLowDewPointAlarm),
    int2bool (OutsideHighDewPointAlarm),
    int2bool (OutsideHighHeatAlarm),
    int2bool (OutsideLowWindChillAlarm),
    int2bool (OutsideHighTHSWAlarm),
    int2bool (OutsideHighSolarRadiationAlarm),
    int2bool (OutsideHighUVAlarm),
    int2bool (OutsideUVDoseAlarm),
    int2bool (OutsideUVDoseAlarmEnabled),
    ExtraTempHumAlarms,
    SoilLeafAlarms,
    TransmitterBatteryStatus,
    (ConsoleBatteryVoltage * 3) / 512 ,
    int2bool (ForecastIconRain),
    int2bool (ForecastIconCloud),
    int2bool (ForecastIconPartlyCloudy),
    int2bool (ForecastIconSun),
    int2bool (ForecastIconSnow),
    ForecastRuleNumber,
    hourmin2time (TimeOfSunrise),
    hourmin2time (TimeOfSunset)
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
  io:format ("'~s',", [E]);
print_elem (E) when is_integer (E) ->
  io:format ("~B,", [E]);
print_elem (E) when is_float (E) ->
  io:format ("~f,", [E]);
print_elem (E) when is_atom (E) ->
  io:format ("~s,", [E]).

f2c (TempF) ->
  (TempF - 32) * 5/9.

hourmin2time (T) ->
  Hour = T div 100,
  Min = T rem 3,
  lists:flatten (io_lib:format ("~b:~b:00", [Hour, Min])).

in2mm (Inches) ->
  Inches * 25.399956.

mph2mps (MpH) ->
  MpH * 1.6 / 3.6.

int2bool (0) ->
  false;
int2bool (_) ->
  true.
