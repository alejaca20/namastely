# Namastely deploy limpio

Esta carpeta contiene solo los archivos necesarios para publicar Namastely en Netlify.

Sube esta carpeta a un repositorio separado de GitHub, por ejemplo `namastely`.

Configuracion de Netlify:

- Build command: `echo 'Static Namastely deploy - no build needed'`
- Publish directory: `.`

Archivos incluidos:

- `index.html`: pagina principal de Namastely.
- `namastely.html`: misma app, por si quieres mantener la ruta `/namastely.html`.
- `supabase-config.js`: configuracion publica de Supabase.
- `netlify.toml`: configuracion para evitar builds de Vite/Bun.

No mezclar esta carpeta con TalentOps.
