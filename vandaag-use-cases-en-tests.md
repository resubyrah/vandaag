# Vandaag — Use cases & tests

Testdatum: 1 november 2026 · App-versie: **v0.5.3** · Testomgeving: geautomatiseerde logica-tests in Node (DOM-stubs, géén login) + handmatige checklist voor UI/sync.

**Kernprincipe: inloggen is altijd optioneel.** De app start altijd lokaal; sync met Google Drive is een uitbreiding die je elk moment kunt hervatten via ☁️ rechtsboven of ☰ → Inloggen.

## Geautomatiseerde tests — resultaat: **29/29 geslaagd** ✅

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