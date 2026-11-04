/* ============================================================
   Saldo Cero — conexión con Supabase

   Proyecto: "Saldo Cero" (kpdbkirkadrvgfxgdjfw)

   Estos dos valores son públicos a propósito: viajan al navegador
   de quien abra la página. Lo que protege tus datos es el login y
   las políticas RLS de esquema.sql, no esconder la llave.

   ⚠️  Nunca pongas aquí la llave "service_role".

   Si dejas los dos campos vacíos, la app sigue funcionando pero
   guarda solo en este navegador.
   ============================================================ */

window.SUPABASE_CONFIG = {
  url: "https://kpdbkirkadrvgfxgdjfw.supabase.co",
  anonKey: "sb_publishable_9_0QVVtRYADfRmOL4sWwIw_a9GRByie"
};
