/*
  XENOS — OPSÆTNING
  Dette er den ENESTE fil, du behøver at ændre for server-IP, Discord,
  webshopprodukter og databaseforbindelse.

  VIGTIGT: Supabase URL + anon/publishable key er offentlige klientværdier.
  Læg ALDRIG en service_role, hemmelig API-nøgle eller betalingsnøgle her.
*/
window.XENOS_CONFIG = {
  serverIp: '',                    // Fx 'play.dinserver.dk' — indtast din RIGTIGE IP
  discordUrl: '',                  // Fx 'https://discord.gg/dininvite'
  storeUrl: '',                    // Fx 'https://dinbutik.tebex.io'
  supportEmail: '',                // Fx 'support@xenosprison.dk'
  privacyPolicyUrl: '',            // HTTPS-link til offentlig privatlivspolitik før du åbner for ansøgninger
  supabaseUrl: '',                 // Supabase > Project Settings > API > Project URL
  supabaseAnonKey: '',             // Supabase > API > publishable/anon key (ALDRIG service_role)
  products: [
    {
      id: 'rank-1',
      name: 'VIP',
      subtitle: 'Eksempel på rank',
      category: 'Ranks',
      accent: 'blue',
      icon: 'crown',
      label: 'RANK',
      features: ['Unikke fordele i spillet', 'Særligt rank-tag', 'Flere muligheder på serveren'],
      price: null,                 // Skriv en pris, fx 49
      checkoutUrl: ''              // Direkte link til dette produkt i din butik
    },
    {
      id: 'rank-2',
      name: 'VIP+',
      subtitle: 'Eksempel på rank',
      category: 'Ranks',
      accent: 'purple',
      icon: 'sparkles',
      label: 'RANK',
      featured: true,
      features: ['Fordele fra tidligere ranks', 'Eksklusive tilføjelser', 'Flere tilpasningsmuligheder'],
      price: null,
      checkoutUrl: ''
    },
    {
      id: 'battlepass',
      name: 'Battlepass',
      subtitle: 'Eksempel på produkt',
      category: 'Ekstra',
      accent: 'gold',
      icon: 'ticket',
      label: 'SÆSON',
      features: ['Premium belønninger', 'Missionsbaseret progression', 'Ekstra indhold i sæsonen'],
      price: null,
      checkoutUrl: ''
    },
    {
      id: 'keys',
      name: 'Nøglepakke',
      subtitle: 'Eksempel på produkt',
      category: 'Nøgler',
      accent: 'teal',
      icon: 'key',
      label: 'NØGLER',
      features: ['Virtuelle nøgler i spillet', 'Belønninger i Xenos', 'Hurtig levering via butikken'],
      price: null,
      checkoutUrl: ''
    }
  ]
};
