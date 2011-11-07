create or replace function weather.trigger_set_id () returns trigger as $$
begin
  new.id = nextval ('weather.zseq_vantage_pro_loop_data');
  new.start_rain_date = '1970-1-1';
  return new;
end $$ language plpgsql;

create trigger a_set_id before insert on weather.vantage_pro_loop_data for each row execute procedure weather.trigger_set_id ();
