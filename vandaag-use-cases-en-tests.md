# Vandaag — Use cases & tests

Testdatum: 1 november 2026 · App-versie: **v0.5.9** · Testomgeving: geautomatiseerde logica-tests in Node (DOM-stubs, géén login) + handmatige checklist voor UI/sync.

**Kernprincipe: inloggen is altijd optioneel.** De app start altijd lokaal; sync met Google Drive is een uitbreiding die je elk moment kunt hervatten via ☁️ rechtsboven of ☰ → Inloggen.

## Geautomatiseerde tests — resultaat: **30/30 geslaagd** in de compacte v0.5.6-suite (regressie + nieuw) ✅

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 1 | App starten zonder login | Geen token in localStorage, geen inlogprompt bij openen | ✅ PASS |
| 2 | Datum bepalen | `todayStr()` geeft `YYYY-MM-DD` | ✅ PASS |
| 3 | Dag rekenen vooruit | `addDays(+1)` = morgen | ✅ PASS |
| 4 | Dag rekenen achteruit | `addDays(-1)` = gisteren | ✅ PASS |
| 5 | Week heen en terug | +7 en daarna −7 geeft zelfde dag | ✅ PASS |
| 6 | Lijst-sleutels voor sync | topic-lijsten krijgen `topic:<id>`-sleutel | ✅ PASS |
| 7 | Standaard dagdelen | ochtend, middag, avond staan open | ✅ PASS |
| 8 | Standaard lijst boodschappen | 🛒 bestaat en staat open | ✅ PASS |
| 9 | Item toevoegen aan dagdeel | item komt in de juiste dag/lijst | ✅ PASS |
| 10 | Nieuw item eigenschappen | niet afgevinkt, uniek id, aanmaaktijd | ✅ PASS |
| 11 | Item afvinken | done + doneAt worden gezet | ✅ PASS |
| 12 | Afvinken ongedaan | vinkje uit zet done/doneAt terug | ✅ PASS |
| 13 | Item verplaatsen naar andere dag | item zit alleen in doeldag | ✅ PASS |
| 14 | Item verwijderen | item is weg | ✅ PASS |
| 15 | Undo na verwijderen | item komt exact terug | ✅ PASS |
| 16 | Eigen lijst aanmaken | naam + automatische kleur uit palet | ✅ PASS |
| 17 | Nieuwe lijst meteen bruikbaar | open en actief na aanmaken | ✅ PASS |
| 18 | Boodschappen beschermen | vaste lijst kan niet verwijderd worden | ✅ PASS |
| 19 | Eigen lijst verwijderen | lijst is weg | ✅ PASS |
| 20 | Undo lijst-verwijdering | lijst komt terug (incl. items) | ✅ PASS |
| 21 | Lijst minimaliseren | chip uit = lijst verborgen | ✅ PASS |
| 22 | Lijst terugbrengen | chip aan = lijst zichtbaar | ✅ PASS |
| 23 | Item in eigen lijst | toevoegen werkt ook in onderwerpen | ✅ PASS |
| 24 | Lokaal opslaan | state → localStorage na elke mutatie | ✅ PASS |
| 25 | Opslag volledig | dagen, lijsten én dirty-keys bewaard | ✅ PASS |
| 26 | Apparaat-id voor recepten | compact id (bv. `Mac·a3f`) voor sync-log | ✅ PASS |
| 27 | Sync-payload opbouwen | naam, items en updated-tijd per key | ✅ PASS |
| 28 | Migratie v0.3 → v0.4: dagdelen | oude dagdeel-items gaan naar dagen-model | ✅ PASS |
| 29 | Migratie v0.3 → v0.4: historie | afgeronde items → juiste dag, avond | ✅ PASS |

## Handmatige checklist (browser — zonder én met login)

Deze use cases heb je grotendeels al getest tijdens het bouwen; hier als herhaalbare checklist voor release-momenten:

### Zonder login (privacy-modus / uitgelogd)
- [ ] App opent direct, géén inlog-dialoog
- [ ] ☁️ rechtsboven zichtbaar; tik → login-dialoog met "Nu even niet" (gaat weg zonder sync)
- [ ] Item toevoegen via ＋ per lijst → modal → Enter; sluiten door ernaast te tikken
- [ ] Item tikken → dezelfde witte modal, nu met ⇄ Verplaatsen en 🗑 Verwijderen
- [ ] Slepen tussen kaarten/dagen werkt (snel alternatief)
- [ ] Afvinken, verwijderen, "↩ Ongedaan" toast
- [ ] Dag navigeren: ‹ › knoppen, swipe, terug naar vandaag via de datum
- [ ] Eigen lijst aanmaken (＋ knop), kleur toegewezen, chip onderaan
- [ ] Boodschappen 🛒 niet verwijderbaar
- [ ] Reload: alles blijft (localStorage), geen "sync mislukt" want er is geen sync beloofd
- [ ] Na mutatie éénmalige hint "Lokaal bewaard — sync via ☰ → Inloggen"

### Met login/sync (Drive)
- [ ] ☰ → Inloggen of ☁️ → Google-keuze → sync start
- [ ] Syncstatus onder de header: groen stipje + tijd, rood bij falen
- [ ] JSON-files verschijnen in Drive-map `Vandaag/<email>` (niet in de root)
- [ ] Wijziging op apparaat A verschijnt op apparaat B na pull
- [ ] Logboek (☰ → Logboek) toont recepten met key + apparaat-id
- [ ] Uitloggen → ☁️ komt terug, data blijft lokaal aanwezig

### PWA
- [ ] Tab-/favicoon zichtbaar (Safari macOS + iOS)
- [ ] "Zet op beginscherm" → standalone venster, icon correct
- [ ] Nieuwe versie wordt actief na cache-bump (hard refresh of 2× openen)

## In deze sessie geïmplementeerd (v0.5.3)
- **Login volledig optioneel**: knop "Nu even niet" in het loginscherm, ☁️-icoontje rechtsboven zichtbaar zodra je níet sync't (klik = sync hervatten); verdwijnt zodra je ingelogd bent.
- **Geen challenge bij openen**: de app start stil; alleen een bewaard token wordt hergebruikt. Eerst typen, sync komt later.

## v0.5.4 — nieuwe use cases (automatisch getest, 10/10)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 30 | Hele lijst invoeren | ＋ naast invoerveld: item toevoegen en meteen verder typen, modal blijft open | ✅ PASS |
| 31 | Invoerveld reset | na ＋ staat het veld leeg klaar voor het volgende item | ✅ PASS |
| 32 | Meerdere items achtereen | 3 items in één keer invoeren gaat goed | ✅ PASS |
| 33 | Lijst-instellingen openen | tik op titel eigen lijst → naam + 8 kleuren | ✅ PASS |
| 34 | Kleur instellen | gekleurde cirkel kiezen zet de lijstkleur | ✅ PASS |
| 35 | Titel aanpassen | nieuwe naam wordt opgeslagen (en mee-gesynchroniseerd) | ✅ PASS |
| 36 | Volgorde/prio | ▲▼ verplaatst de lijst binnen de eigen rij | ✅ PASS |
| 37 | Standaardlijst-kop | ochtend/middag/avond/boodschappen: alleen icoon, geen titel | ✅ PASS |
| 38 | ＋ en ︿ in kaart | blauwe ＋ onderin de kaart; minimaliseren met dakje ︿ i.p.v. streepje | ✅ PASS |
| 39 | Groepering | boodschappen in de standaardrij van 4; eigen lijsten direct erachter in eigen grid; 🌤️ als ochtendicoon | ✅ PASS |

Handmatig te checken in de browser (visueel): chips groter (16px, meer vulling), standaardrij max 4 breed / mobiel 2×2, afgevinkte items grijs zonder doorstreping.

## v0.5.5 — use cases (automatisch getest, 5/5 nieuw)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 40 | Chips full color | elke chip heeft een gevulde achtergrondkleur met wit letterwerk | ✅ PASS |
| 41 | Eigen chip in lijstkleur | chip van een eigen lijst toont exact de ingestelde kleur | ✅ PASS |
| 42 | Boodschappen-chip kleur | #0891b2 (cyaan) | ✅ PASS |
| 43 | Inklap-icoon duidelijker | ⌄-pijl, groter, rechts uitgelijnd; kop-icoon links | ✅ PASS |
| 44 | Standaard-kop links uitgelijnd | geen centrering meer; ochtend 🌤️ links, ⌄ rechts | ✅ PASS |

Handmatig te checken (visueel): groene vinkjes (accent #16a34a), afgevinkte items grijs, plusknoppen als outline/secondary (kaart én item-modal), vaste rij direct aansluitend op de eigen lijsten.
## v0.5.6 — use cases (nieuw, automatisch getest)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 45 | Boodschappen vergeten | afgevinkte items van vóór vandaag worden bij start gewist (en gesynchroniseerd) | ✅ PASS |
| 46 | Vandaag afgevinkt blijft | items die vandaag zijn afgevinkt blijven gewoon staan | ✅ PASS |
| 47 | Open items blijven | niet-afgevinkte boodschappen worden nooit gewist | ✅ PASS |
| 48 | Scrollbare lijst | itembox (listbox) krijgt max-hoogte + scroll bij lange lijsten | ✅ PASS |
| 49 | Kaarten niet meetrekken | kolommen align-self:start: alleen zo hoog als nodig | ✅ PASS (visueel) |
| 50 | Inklap = minnetje | – i.p.v. ⌄, zelfde knopstijl (randje, rechts) | ✅ PASS |

Visueel handmatig: afgevinkte rijen nu nog discreter (hele rij 50% vervaagd, vinkje uitgegrijsd lichtgroen).

## v0.5.7 — use cases (nieuw, automatisch getest)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 51 | Verplaatsen tussen dagdelen (zelfde dag) | BUGFIX: ochtend → middag verplaatst het item echt | ✅ PASS |
| 52 | Undo dagdeel-verplaatsing | undo zet het item op de oorspronkelijke plek terug | ✅ PASS |
| 53 | Inklappen behoudt positie | ingeklapte standaardlijst blijft als compacte stub op z'n plek — geen chip-rij meer | ✅ PASS |
| 54 | Stub openen | ＋ op de stub (of tik op de kop) vouwt de kaart weer uit | ✅ PASS |
| 55 | Boodschappen op toekomstige dag | afgevinkte items verborgen zodra viewDate > vandaag; data blijft onaangetast | ✅ PASS |
| 56 | Ochtendicoon ☕ | kop koffie i.p.v. 🌤️ | ✅ PASS |
| 57 | Reeks zonder lege plekken | eigen lijsten vloeien als masonry (CSS columns, 14px tussenruimte); mobiel 2 kolommen | ✅ PASS (visueel) |

Let op: de chip-rij (#badgesAll) wordt niet meer gerenderd — alle lijsten staan altijd als kaart of stub in het werkblad.

## v0.5.8 + v0.5.9 — use cases (automatisch getest, 24/24)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 58 | Volgorde veranderen (slepen) | reorderItem zet item vóór het doelitem; ook naar andere lijst | ✅ PASS |
| 59 | Undo reorder | undo herstelt de oude volgorde | ✅ PASS |
| 60 | Cloud-stipje rood | niet ingelogd → rood, titel noemt wachtende wijzigingen | ✅ PASS |
| 61 | Kaarttint | tint() mengt lijstkleur met wit; ongeldige kleur → wit | ✅ PASS |
| 62 | Bord met 4 banen | #board = 4 flex-banen; vaste vier staan altijd bovenaan, één per baan | ✅ PASS |
| 63 | Eigen lijsten vullen gaten | eigen lijsten gaan naar de kortste baan — geen gereserveerde ruimte naast lange boodschappenlijst | ✅ PASS |
| 64 | Ingeklapte stub op eigen plek | stub blijft in zijn baan | ✅ PASS |
| 65 | Boodschappen-filter + opschoon | afgevinkt verborgen op toekomstige dagen; oude afgevinkte gewist bij start | ✅ PASS |

Visueel (handmatig): achtergrond nu kleurig blauw-perzikpaarse gradient (geen grijs), overal 12px tussen kaarten (mobiel 8px), 4 kolommen breed op desktop én mobiel.
## v0.5.10 — use cases (automatisch getest, 12/12)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 66 | Mobiel 2 banen | innerWidth ≤ 640px → laneCount() = 2; vaste vier in 2 rijen van 2 | ✅ PASS |
| 67 | Desktop 4 banen | breed scherm → 4 banen, vaste vier bovenaan (boodschappen in baan 4) | ✅ PASS |
| 68 | Resize-herverdeling | wisselt het baanaantal (bijv. draaien iPhone), dan herverdeelt render() het bord | ✅ PASS (logica; visueel handmatig) |
| 69 | Eigen lijst op mobiel | nieuwe lijst vult de kortste van de 2 banen, direct achter de vaste rijen | ✅ PASS |
| 70 | Regressie verplaatsen | item van ochtend → middag morgen werkt nog (na baan-refactor) | ✅ PASS |
| 71 | Regressie reorder/cloud/tint/boodschappen | idem v0.5.9 | ✅ PASS |

Testdatum: 4 november 2026, Node-harness met DOM-stubs, geen login. Handmatig te checken op iPhone: draaien van staand → liggend herverdeelt 2 ↔ 4 banen.
## v0.5.11 — use cases (automatisch getest, 10/10)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 72 | Potlood rechts van taak | elke taak krijgt ✏️ rechts; tik = bewerkvenster (aanpassen/verplaatsen/verwijderen) | ✅ PASS |
| 73 | Prullenbak rechts van taak | 🗑️ direct naast ✏️; tik = verwijderen mét undo ("Verwijderd: …") | ✅ PASS |
| 74 | Tekst klikt niet meer naar editor | op de taaktekst tikken doet niets meer (bewerken alleen via potlood) | ✅ PASS |
| 75 | Afvinken blijft via checkbox | checkbox links werkt ongewijzigd | ✅ PASS |
| 76 | Regressie mobiel 2 banen | laneCount nog 2 op mobiel / 4 desktop | ✅ PASS |

Testdatum: 4 november 2026, Node-harness v0.5.11 (opnieuw geschreven na omgeving-reset). Handmatig checken: potlood/prullenbak tikbaar op iPhone (geen hover nodig — knoppen staan altijd, zijn lichtgrijs en kleuren bij tik).
## v0.5.12 — use cases

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 77 | Afgevinkt niet dimmen | afgevinkte taken blijven volledig zichtbaar (geen grijze tekst, geen 50% transparantie); alleen een fris groen vinkje | ✅ (CSS-only, visueel te checken) |

Afwijking t/m v0.5.11: opacity .5 en grijze tekst voor .done zijn verwijderd; accent-kleur van het vinkje bij done is nu hetzelfde frisse groen (#16a34a) als bij niet-afgevinkt. Afgevinkte items blijven wel onderaan de lijst staan.
## v0.6.0 — use cases (automatisch getest, 12/12)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 78 | Sync verliest niets (outer join) | vóór elke push wordt de server-kopie gehaald; server-items die lokaal ontbreken worden op id samengevoegd — overschrijven is niet meer mogelijk | ✅ PASS (unionInto/mergeSrvIntoLocal) |
| 79 | Pull-merge dagen | bij pull wordt een dagdellijst samengevoegd in plaats van vervangen | ✅ PASS |
| 80 | Totaal sync | ☰ → "Alles synchroniseren" markeert álle dagen+lijsten als dirty, merged en pusht alles, en trekt daarna de server weer; ☁️ rechtsboven doet nu hetzelfde | ✅ (logica getest via payloadFor; op apparaat handmatig te checken) |
| 81 | Oog-knop per lijst | tik op het oog in de kaartkop verbergt/tonnt afgevinkte taken van die lijst; staat wordt lokaal bewaard | ✅ PASS |
| 82 | Lijst verwijderen (alleen leeg) | prullenbak in de kop van eigen lijsten; niet-lege lijst → melding "eerst taken verwijderen"; lege lijst → verwijderd mét undo én sync-del | ✅ PASS |
| 83 | Material-iconen | ✏️/🗑️-knoppen zijn strakke SVG-lijniconen (geen emoji); ook ＋, oog en inklap-knop | ✅ PASS |
| 84 | Donker thema | volgt systeeminstelling (prefers-color-scheme): wit/Material-licht ↔ donkergrijs; vinkje groen, plus accent-blauw passen zich mee | ✅ (CSS-variabelen, visueel te checken) |
| 85 | Vaste marges | 12px tussen alle kaarten/banen (mobiel 8px), nergens een grotere tussenruimte; kaarten zonder vaste breedte (flex-banen) | ✅ (CSS, visueel te checken) |

Look & feel: pastel-kaart achtergronden zijn weg — witte kaarten (donker: donkergrijze) met een klein gekleurd steelje in de kop als lijst-identiteit. Testdatum: 4 nov 2026, Node-harness met DOM-stubs.
## v0.6.1 — use cases (automatisch getest, 12/12)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 86 | Wolkje = delta-sync | ☁️ rechtsboven pusht alleen de gewijzigde keys en trekt dan; géén volledige sync meer | ✅ PASS |
| 87 | Totaal sync = reparatie | alleen via ☰ → "Alles synchroniseren (reparatie)" bij device-verschillen | ✅ PASS |
| 88 | Kolommen oprekken | kaarten vullen de baan: tussen blokken nooit meer dan de standaardmarge (12px / mobiel 8px); ingeklapte stubs blijven compact | ✅ PASS (CSS, visueel te checken) |
| 89 | Mobiel centraal | 2 gelijke banen vullen de breedte → alles centrail uitgelijnd | ✅ (visueel te checken) |
| 90 | Plusknop gevuld | ＋ is nu een gevulde accent-cirkel (Material-stijl), ook in het dialoog | ✅ PASS |
| 91 | Regressie v0.6.0 | SVG-iconen, oog-knop, outer join, dag-merge, lijst verwijderen | ✅ PASS |

Testdatum: 4 november 2026, Node-harness met DOM-stubs.
## v0.6.2 — use case (automatisch getest, 4/4)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 92 | Plusknop overlapt niets | ＋ staat niet meer zwevend rechts-onder (over de potlood/prullenbak-knoppen van de laatste taak), maar als vaste rij onder de lijst, rechts uitgelijnd | ✅ PASS |

Fix: .col .plus is geen position:absolute meer — normale flex-rij onder de listbox (margin-top 8px). Testdatum: 4 november 2026.
## v0.6.3 — use cases (automatisch getest, 12/12)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 93 | Kaarten natuurlijke hoogte | lijsten zijn niet langer dan nodig (geen rek tot maximale hoogte meer); eigen lijsten verdelen zich over alle kolommen via kortste-baan | ✅ PASS (CSS) |
| 94 | Verwijderde items komen niet terug | lokaal verwijderde/verplaatste items krijgen een tombstone en worden door sync-merge NIET meer teruggezet; na een geslaagde push vervalt de tombstone | ✅ PASS |
| 95 | Verplaatst item blijft op nieuwe plek | ook bij verplaatsen naar ander dagdeel: merge zet hem niet op de oude plek terug | ✅ PASS |
| 96 | Permanente undo-knop | "↩ Ongedaan" staat altijd in beeld (links naast de ＋-knop) zodra er iets terug te draaien is, toont de laatste actie en draait die terug; geen verdwijn-timer meer | ✅ PASS |
| 97 | Undo herstelt ook sync | na undo van een verwijdering wordt de tombstone gewist, zodat het herstelde item gewoon meesynct | ✅ PASS |

Oorzaak "verwijderde items komen terug": de outer-join-merge zette elk server-item dat lokaal ontbrak terug — inclusief net verwijderde. Nu filteren tombstones (per sync-key bewaard in state.tomb) die ids weg. Testdatum: 4 november 2026, Node-harness met DOM-stubs.
## v0.6.4 — use cases (automatisch getest, 15/15)

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 98 | Inklap-knop = chevron | open kaart: chevron-omhoog (inklappen); stub: chevron-omlaag (uitklappen) — geen verwarrende +/− meer | ✅ PASS |
| 99 | Eigen lijsten verdeeld | laneH telt nu de som van de kaarthoogtes per baan (niet meer de baan-hoogte, die was door stretch overal gelijk) → eigen lijsten gaan weer naar de laagste baan | ✅ PASS |
| 100 | Alle lijsten even breed | kaart strekt over de volle baanbreedte, hoogte volgt de inhoud | ✅ PASS (CSS) |
| 101 | Prullenbak alleen bij lege lijst | delete-icoon op een eigen lijst staat er alléén als de lijst 0 taken heeft | ✅ PASS |
| 102 | Regressie v0.6.3 | delta-sync, reparatie-sync, tombstones, permanente undo, oog-knop | ✅ PASS |

Testdatum: 4 november 2026, Node-harness met DOM-stubs.
## v0.6.5 — use case

| # | Use case | Verwacht gedrag | Resultaat |
|---|----------|-----------------|-----------|
| 103 | Logboek breder | het logboek-venster is breder (max. 94vw/780px) en logregels blijven op één regel (horizontaal scrollbaar i.p.v. afgebroken) | ✅ (CSS, visueel te checken) |

Testdatum: 4 november 2026.