-- Run this ONCE in Supabase SQL Editor after the original setup.
-- Adds the fields needed for real map pins and richer business profiles.
alter table public.business_applications add column if not exists latitude double precision;
alter table public.business_applications add column if not exists longitude double precision;
alter table public.business_applications add column if not exists products jsonb not null default '[]'::jsonb;
alter table public.business_applications add column if not exists services jsonb not null default '[]'::jsonb;
alter table public.business_profiles add column if not exists latitude double precision;
alter table public.business_profiles add column if not exists longitude double precision;
alter table public.business_profiles add column if not exists products jsonb not null default '[]'::jsonb;
alter table public.business_profiles add column if not exists services jsonb not null default '[]'::jsonb;

-- Private storage for business verification documents and portfolio images.
insert into storage.buckets (id,name,public)
values ('business-documents','business-documents',false)
on conflict (id) do nothing;

drop policy if exists "owners upload business documents" on storage.objects;
create policy "owners upload business documents" on storage.objects
for insert to authenticated
with check (bucket_id='business-documents' and (storage.foldername(name))[1]=auth.uid()::text);

drop policy if exists "owners read business documents" on storage.objects;
create policy "owners read business documents" on storage.objects
for select to authenticated
using (bucket_id='business-documents' and ((storage.foldername(name))[1]=auth.uid()::text or exists(select 1 from public.admin_users a where lower(a.email)=lower((auth.jwt()->>'email')))));

drop policy if exists "owners update business documents" on storage.objects;
create policy "owners update business documents" on storage.objects
for update to authenticated
using (bucket_id='business-documents' and (storage.foldername(name))[1]=auth.uid()::text)
with check (bucket_id='business-documents' and (storage.foldername(name))[1]=auth.uid()::text);

drop policy if exists "owners delete business documents" on storage.objects;
create policy "owners delete business documents" on storage.objects
for delete to authenticated
using (bucket_id='business-documents' and (storage.foldername(name))[1]=auth.uid()::text);
