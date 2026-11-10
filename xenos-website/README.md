# XENOS PRISON — officiel hjemmeside

Et unikt, responsivt design til **xenosprison.dk** med Xenos' eget logo, forside, forum, butik, ansøgninger, regler og infoside. Kildekoden ligger i GitHub, og **Cloudflare Pages anbefales til selve publiceringen**, fordi sitet også skal have butik.

## Hvad virker allerede?

- Alle sider, menuer, mobilvisning og knapper til navigation.
- Rigtigt Xenos-logo, forbedret indlæsning (WebP), browser-ikon, SEO-metatags.
- Forum med kategorier, søgning og trådvisning. **Indtil databasen er sat op, vises kun tydeligt mærkede eksempeltråde.**
- Butik med kategorier og produktkort. Betalingslinks åbner Tebex, når du har indsat dem. Priser og produkttekster er eksempler, ikke din faktiske butik.
- Ansøgningsformularer til **Staff, Bygger og YouTuber**.
- Med Supabase: email/password-login, oprettelse af tråde, svar, indsendelse af ansøgninger og visning af egne ansøgningsstatusser.
- Hjemmesiden indeholder ingen skjulte betalinger, uvirksomme “sendt!”-beskeder eller opdigtede online-spillertal.

**Vigtigt:** GitHub Pages er kun statisk hosting. En database er nødvendig for ægte login, forum og ansøgninger. En betalingsudbyder er nødvendig for ægte køb. Xenos-sitet er derfor en færdigdesignet frontend med mulighed for at aktivere de funktioner, når du forbinder tjenesterne.

## 1. Test hjemmesiden lokalt

Åbn `index.html` i din browser. For at teste med en lokal server kan du også køre:

```bash
python -m http.server 8000
```

Åbn derefter `http://localhost:8000`.

## 2. Upload til GitHub

1. Log på GitHub og lav et repository, for eksempel `xenos-website`.
2. Vælg **Add file → Upload files** og upload **indholdet** af denne mappe (altså `index.html`, `assets/`, `css/`, `js/` osv. direkte i repoets rod). Husk også den skjulte `.nojekyll`, hvis du vil bruge GitHub Pages.
3. Gem med **Commit changes**.

Du kan bruge et privat repo med Cloudflare Pages. GitHub bliver stedet, hvor du opdaterer koden, billederne og teksterne.

## 3. Publicer med Cloudflare Pages (anbefalet til Xenos)

**Hvorfor?** GitHub Pages er godt til fremvisning af projekter, men GitHubs vilkår siger, at tjenesten **ikke må anvendes som gratis hosting til en e-handelswebsite**. Da Xenos skal have en butik, er det mest hensigtsmæssigt at bruge GitHub til koden og Cloudflare Pages til hosting. Se: https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits

1. Opret en konto på https://dash.cloudflare.com.
2. Gå til **Workers & Pages → Create application → Pages → Connect to Git**.
3. Vælg GitHub, og forbind repoet `xenos-website`.
4. Vælg produktionsgren `main`. Vælg ingen framework-preset / `None`, build command `exit 0` og **output directory `.`** (projektets rod, hvor `index.html` ligger).
5. Publicer. Cloudflare tildeler først et `*.pages.dev`-domæne, som du kan teste.
6. Under **Pages → projektet → Custom domains**, tilføj `xenosprison.dk`.
7. For at bruge domænets rod (`xenosprison.dk`) kræver Cloudflare Pages, at du tilføjer domænet til Cloudflare og ændrer domænets **navneservere** hos din domæneudbyder (fx one.com) til præcis de to navneservere, Cloudflare viser. **Kopiér ikke tilfældige navneservere fra andre.**
8. Når domænet er aktivt og HTTPS virker, kan du bruge den officielle adresse. Cloudflare genudgiver automatisk hjemmesiden ved ændringer på GitHub.

Officielle guides: https://developers.cloudflare.com/pages/get-started/git-integration/ og https://developers.cloudflare.com/pages/configuration/custom-domains/

**Vigtigt:** Hvis dit domæne også håndterer e-mail eller Minecraft-server, skal de eksisterende DNS-records (MX, TXT, A/SRV osv.) bevares korrekt ved flytning af navneservere. Cloudflare scanner dem som regel ved opsætning, men du skal kontrollere dem.

## Alternativ: GitHub Pages til privat designforhåndsvisning

Brug kun dette alternativ, hvis sitet bruges som en almindelig projektside/demonstration uden kommerciel webshop, og din anvendelse overholder GitHubs regler.

1. Sæt repoet til **Public**, hvis du bruger GitHub Free.
2. Gå til repoets **Settings → Pages → Deploy from a branch → main → /(root) → Save**.
3. Under **Custom domain** indtaster du `xenosprison.dk` og gemmer, inden DNS ændres. Filen `CNAME` er allerede med i projektet.
4. Hos din domæneudbyder tilføjes disse `A`-records på `@`:

| Type | Host | Værdi |
|------|------|-------|
| A | @ | 185.199.108.153 |
| A | @ | 185.199.109.153 |
| A | @ | 185.199.110.153 |
| A | @ | 185.199.111.153 |

5. Tilføj eventuelt `www` som CNAME til `DIT-BRUGERNAVN.github.io`. Slå **Enforce HTTPS** til i GitHub Pages.

Officiel guide: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site

**Bemærk:** Minecraft-adressen er adskilt fra webdomænet. Vil du bruge fx `mc.xenosprison.dk` i Minecraft, kræver det DNS mod din faktiske spilserver og eventuelt en SRV-record.

## 4. Sæt Xenos-info og produkter ind

Åbn **`js/config.js`** og indtast:

```js
serverIp: 'DIN_RIGTIGE_SERVER_IP',
discordUrl: 'https://discord.gg/DIT_INVITE',
storeUrl: 'https://DIN_BUTIK.tebex.io',
supportEmail: 'DIN_SUPPORT_EMAIL',
privacyPolicyUrl: 'https://DIT_DOMÆNE/PRIVATLIVSPOLITIK',
```

Ret i samme fil `products` til dine **rigtige** produkter, fordele, priser og direkte `checkoutUrl`-links. Hvis du ikke har priser klar, bliver “Kommer snart” vist.

**Butik:** [Tebex](https://www.tebex.io/) er lavet til køb af digitale Minecraft-pakker og kan kobles til spilserveren. Start med Tebex Webstore Builder (enklest), eller tilslut senere deres Headless API, hvis checkout skal ske inde i dit eget design. **Du må aldrig lægge hemmelige Tebex-nøgler i GitHub-repoet.** For fuldt indbygget køb kræves en sikker backend.

Læs om integrationsmulighederne: https://docs.tebex.io/developers/integration-methods

## 5. Aktivér forum, brugere og ansøgninger med Supabase

1. Opret et projekt på https://supabase.com.
2. Åbn **SQL Editor**, indsæt hele indholdet fra **`supabase/schema.sql`**, og kør scriptet én gang. Hvis du har kørt dele tidligere, kan eksisterende policies/triggers give en “already exists”-fejl — brug derfor et tomt projekt ved førstegangsopsætning.
3. Gå til **Project Settings → API** og find `Project URL` og den offentlige `anon` / `publishable` key.
4. Sæt dem ind i **`js/config.js`**:

```js
supabaseUrl: 'https://DITPROJEKT.supabase.co',
supabaseAnonKey: 'DIN_PUBLISHABLE_ELLER_ANON_KEY',
```

5. Under **Authentication → URL Configuration** skal **Site URL** være `https://xenosprison.dk`, og du skal tilføje eventuelle redirect URL'er, som bruges i dit login-flow.
6. Aktivér **email confirmation** og konfigurer mailudsendelse via Supabase/Auth til produktion.
7. Registrér en konto på hjemmesiden. Hvis du vil moderere ansøgninger, kan du finde brugerens UUID under Supabase **Authentication → Users** og indsætte det som site-admin med SQL-linjen nederst i schema.sql.
8. Ansøgninger kan gennemgås under **Table Editor → applications**. Her kan du manuelt sætte `status` til fx `under behandling` / `godkendt` / `afvist`.

**Hvad Supabase gør:** RLS-politikker sørger for, at folk kun kan indsende deres egne ansøgninger og kun se deres egne (admin kan også se dem). Forum er offentligt læsbart, men kræver login for at oprette opslag/svar. Der er basale rate limits mod spam. Forum-moderation kan foretages via Supabase Table Editor, men en staff-kontrolside er endnu ikke bygget.

**Sikkerhed:** Kun en **publishable/anon key** må ligge i frontend. **Aldrig `service_role`-nøglen.** RLS skal forblive slået til. Supabase Auth-meddelelser vises som standard; tilpas oversættelser og e-mailtemplater, hvis det ønskes.

## Inden offentlig lancering

- Udskift alle eksempelprodukter med rigtige priser, vilkår og billeder.
- Indsæt korrekt server-IP, Discord-invite og supportmail.
- Færdiggør serverreglerne (den nuværende regelside er mærket som et udkast).
- Før ansøgningsformularerne kan indsendes, skal du sætte `privacyPolicyUrl` i `js/config.js` til en offentlig privatlivspolitik.
- Udarbejd **privatlivspolitik** og oplys dataansvarlig, formål, databehandling, opbevaring, sletning, klagevejledning og evt. databehandlere. Websitet samler personoplysninger fra konti, forum og ansøgninger; et flueben alene er ikke nok til GDPR-overholdelse.
- Udarbejd handelsbetingelser, fortrydelses-/refusionsinformation og oplysninger om sælger, inden der modtages køb.
- Overvej CAPTCHA, moderation, alderspolitik, kontosletning og automatisk sletning af gamle ansøgninger, før du inviterer mange spillere.
- Test at domæne, HTTPS og databaseregler fungerer i browseren.

## Projektfiler

```text
index.html               Hele hjemmesiden (GitHub Pages entrypoint)
CNAME                    Domænet xenosprison.dk
.nojekyll                GitHub Pages static assets
css/styles.css           Design, animationer og mobilvisning
js/config.js             Server-IP, Discord, produkter, Tebex og Supabase
js/app.js                Sider, interaktioner, login, forum og ansøgninger
assets/xenos-logo.webp   Optimeret originalt Xenos-logo
assets/xenos-logo.png    Originalt Xenos-logo i PNG
assets/favicon.png       Favicon
assets/share-preview.png Social preview (transparent)
supabase/schema.sql      Forum + ansøgninger + Row Level Security
```

Teknologi: HTML, CSS, JavaScript — ingen npm, React, Maven eller buildproces kræves.
