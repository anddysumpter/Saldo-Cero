-- ============================================================
--  Saldo Cero — esquema para Supabase
--  Pégalo completo en Supabase → SQL Editor → Run.
--  Se puede correr varias veces sin romper nada.
-- ============================================================

-- Una fila por usuario con todo su estado (tarjetas, deudas,
-- movimientos y configuración) guardado como JSON.
create table if not exists public.estado_finanzas (
  user_id        uuid primary key references auth.users(id) on delete cascade,
  datos          jsonb       not null default '{}'::jsonb,
  actualizado_en timestamptz not null default now()
);

-- RLS: sin esto, cualquiera con la anon key leería tus saldos.
alter table public.estado_finanzas enable row level security;

drop policy if exists "leer lo propio"       on public.estado_finanzas;
drop policy if exists "insertar lo propio"   on public.estado_finanzas;
drop policy if exists "actualizar lo propio" on public.estado_finanzas;
drop policy if exists "borrar lo propio"     on public.estado_finanzas;

create policy "leer lo propio" on public.estado_finanzas
  for select using (auth.uid() = user_id);

create policy "insertar lo propio" on public.estado_finanzas
  for insert with check (auth.uid() = user_id);

create policy "actualizar lo propio" on public.estado_finanzas
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "borrar lo propio" on public.estado_finanzas
  for delete using (auth.uid() = user_id);

-- La fecha de actualización se pone sola en cada escritura.
-- SECURITY INVOKER (lo normal) para que no quede expuesta como
-- función llamable desde la API: solo la usa el trigger.
create or replace function public.tocar_actualizado_en()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.actualizado_en = now();
  return new;
end;
$$;

revoke all on function public.tocar_actualizado_en() from public, anon, authenticated;

drop trigger if exists trg_estado_finanzas_touch on public.estado_finanzas;
create trigger trg_estado_finanzas_touch
  before update on public.estado_finanzas
  for each row execute function public.tocar_actualizado_en();

-- ============================================================
--  Comprobación rápida: después de correr esto, en Table Editor
--  debe aparecer "estado_finanzas" con el candado de RLS activo.
-- ============================================================
