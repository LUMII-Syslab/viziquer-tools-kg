truncate table public.endpoints restart identity cascade;
truncate table public.schemata restart identity cascade;

call public.register_schemata();
