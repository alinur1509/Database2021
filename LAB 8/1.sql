-- a
create function add1(ans int)
returns int
language plpgsql
as
    $$
    begin
        ans = ans + 1;
        return ans;
    end;
    $$;

select * from add1(2);

-- b
create function sum(f int, s int)
returns int
language plpgsql
as
    $$
    declare ans int;
    begin
        ans = f + s;
        return ans;
    end;
    $$;

select * from sum(332, 68);


-- c
create or replace function inc(val integer) returns boolean as
    $$
    begin
        if val % 2 = 0
            then return true;
        else
            return false;
        end if;
    end;
    $$
language plpgsql;

select inc(3);
-- d
create or replace function inc5(password varchar) returns varchar as
    $$
    begin
        if length(password) >= 10
            then return 'ACCEPT';
        else
            return 'ERROR';
        end if;
    end;
    $$
language plpgsql;

drop function inc5;

select inc5('12adasda363463');


-- e
create function outputs(inp varchar, out first varchar, out second varchar)
as
    $$
        begin
        first = split_part(inp,' ', 1);
        second = split_part(inp,' ', 2);
    end
    $$
language plpgsql;


select * from outputs('Alinur Yelemessov');
drop function outputs;


drop function outputs;

