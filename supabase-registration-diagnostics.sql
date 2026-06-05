select
  'plans' as check_name,
  count(*)::text as result
from public.plans
where name = 'Mensual 8 clases'
union all
select
  'handle_new_user_function' as check_name,
  count(*)::text as result
from pg_proc
where proname = 'handle_new_user'
union all
select
  'on_auth_user_created_trigger' as check_name,
  count(*)::text as result
from pg_trigger
where tgname = 'on_auth_user_created';

select
  id,
  email,
  email_confirmed_at,
  created_at
from auth.users
order by created_at desc
limit 10;

select
  id,
  role,
  full_name,
  email,
  created_at
from public.profiles
order by created_at desc
limit 10;

select
  students.id,
  students.profile_id,
  plans.name as plan_name,
  students.created_at
from public.students
left join public.plans on plans.id = students.plan_id
order by students.created_at desc
limit 10;
