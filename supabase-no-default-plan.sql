alter table public.students
alter column plan_id drop not null;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  student_name text;
begin
  student_name := coalesce(
    new.raw_user_meta_data ->> 'full_name',
    split_part(new.email, '@', 1)
  );

  insert into public.profiles (id, role, full_name, email)
  values (
    new.id,
    'student',
    student_name,
    new.email
  )
  on conflict (id) do update
  set
    role = 'student',
    full_name = excluded.full_name,
    email = excluded.email;

  insert into public.students (profile_id, plan_id)
  values (
    new.id,
    null
  )
  on conflict (profile_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
