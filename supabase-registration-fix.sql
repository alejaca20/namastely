insert into public.plans (name, monthly_classes, is_active)
values ('Mensual 8 clases', 8, true)
on conflict (name) do update
set monthly_classes = excluded.monthly_classes,
    is_active = true;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  default_plan_id uuid;
  student_name text;
begin
  select id
  into default_plan_id
  from public.plans
  where name = 'Mensual 8 clases'
  limit 1;

  if default_plan_id is null then
    select id
    into default_plan_id
    from public.plans
    where is_active = true
    order by monthly_classes
    limit 1;
  end if;

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

  if default_plan_id is not null then
    insert into public.students (profile_id, plan_id)
    values (
      new.id,
      default_plan_id
    )
    on conflict (profile_id) do nothing;
  end if;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

drop policy if exists "Users update own profile" on public.profiles;

create policy "Users update own profile"
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());
