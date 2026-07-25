const MONTHS = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]

function prikaziDokument(documentId) {
  document.querySelectorAll(".doc").forEach((doc) => doc.classList.remove("active"))
  const el = document.getElementById(documentId)
  if (el) el.classList.add("active")
}

function zatvoriSveDokumente() {
  document.querySelectorAll(".doc").forEach((doc) => doc.classList.remove("active"))
}

function setField(root, field, value) {
  const text =
    value !== undefined && value !== null && String(value).trim() !== "" ? String(value) : "—"
  root.querySelectorAll(`[data-field="${field}"]`).forEach((el) => {
    el.textContent = text
  })
}

function parseIme(ime) {
  const parts = (ime || "NEPOZNATO").trim().split(/\s+/).filter(Boolean)
  if (parts.length === 0) return { potpis: "—" }
  if (parts.length === 1) {
    return { potpis: parts[0].toLowerCase() }
  }
  const potpis = parts.map((p) => p.charAt(0).toUpperCase() + p.slice(1).toLowerCase()).join(" ")
  return { potpis }
}

function normalizeClassList(lista) {
  if (Array.isArray(lista)) {
    return lista.map((s) => String(s).trim().toUpperCase()).filter(Boolean)
  }
  return String(lista || "")
    .split(/[,+]/g)
    .map((s) => s.trim().toUpperCase())
    .filter(Boolean)
}

function formatClass(lista) {
  const cats = [...new Set(normalizeClassList(lista))]
  if (!cats.length) return "—"
  return cats.sort().join(" + ")
}

const DL_CATS_DEFAULT = [
  { letter: "A", label: "Kategorija A", owned: false },
  { letter: "B", label: "Kategorija B", owned: false },
  { letter: "C", label: "Kategorija C", owned: false },
]

function renderDlCategoryBadges(pregled) {
  const container = document.getElementById("dl-cat-badges")
  if (!container) return

  const rows = Array.isArray(pregled) && pregled.length ? pregled : DL_CATS_DEFAULT
  const ownedLetters = rows.filter((r) => r.owned).map((r) => r.letter)

  container.innerHTML = ""
  rows.forEach((row) => {
    const cell = document.createElement("div")
    cell.className = `cat-cell${row.owned ? " cat-cell--on" : " cat-cell--off"}`
    cell.innerHTML = `<span class="cat-cell-letter">${row.letter}</span><span class="cat-cell-label">${row.label || ""}</span>`
    container.appendChild(cell)
  })

  return ownedLetters
}

function formatPolShort(sex) {
  const s = String(sex ?? "").toLowerCase().trim()
  if (s === "m" || s === "male" || s === "0" || s === "muški" || s === "muski") return "MALE"
  if (s === "f" || s === "female" || s === "1" || s === "ženski" || s === "zenski") return "FEMALE"
  return "—"
}

function pad2(n) {
  return String(n).padStart(2, "0")
}

function todayDmY() {
  const d = new Date()
  return `${pad2(d.getDate())}/${pad2(d.getMonth() + 1)}/${d.getFullYear()}`
}

function expireDmYPlusYears(years) {
  const d = new Date()
  d.setFullYear(d.getFullYear() + years)
  return `${pad2(d.getDate())}/${pad2(d.getMonth() + 1)}/${d.getFullYear()}`
}

function formatExpires(dateStr) {
  if (!dateStr || dateStr === "—") {
    return formatExpires(expireDmYPlusYears(5))
  }

  const raw = String(dateStr).trim()
  const iso = raw.match(/^(\d{4})-(\d{2})-(\d{2})/)
  if (iso) {
    const m = parseInt(iso[2], 10) - 1
    if (m >= 0 && m < 12) return `${MONTHS[m]} ${iso[1]}`
  }

  const dmY = raw.match(/^(\d{1,2})[./](\d{1,2})[./](\d{4})$/)
  if (dmY) {
    const m = parseInt(dmY[2], 10) - 1
    const y = dmY[3]
    if (m >= 0 && m < 12) return `${MONTHS[m]} ${y}`
  }

  const parts = raw.split(/[./-]/).filter(Boolean)
  if (parts.length >= 3) {
    let day, month, year
    if (parts[0].length === 4) {
      year = parts[0]
      month = parseInt(parts[1], 10)
      day = parts[2]
    } else {
      day = parts[0]
      month = parseInt(parts[1], 10)
      year = parts[2].length === 2 ? `20${parts[2]}` : parts[2]
    }
    const m = month - 1
    if (m >= 0 && m < 12) return `${MONTHS[m]} ${year}`
  }

  return raw.toUpperCase()
}

function ensureDates(playerData) {
  const issued =
    playerData.datum_izdavanja || playerData.issuedDate || todayDmY()
  const expire =
    playerData.datum_isteka ||
    playerData.expireDate ||
    playerData.vazi_do ||
    expireDmYPlusYears(5)
  return { issued, expire }
}

const PARISHES = [
  "Kingston",
  "St. Andrew",
  "St. Thomas",
  "Portland",
  "St. Mary",
  "St. Ann",
  "Trelawny",
  "St. James",
  "Hanover",
  "Westmoreland",
  "St. Elizabeth",
  "Manchester",
  "Clarendon",
  "St. Catherine",
]

function hashFromId(citizenid) {
  const raw = (citizenid || "").toString()
  let n = 0
  for (let i = 0; i < raw.length; i++) n += raw.charCodeAt(i)
  return n
}

function visinaIzId(citizenid) {
  return 168 + (hashFromId(citizenid) % 28)
}

function parishFromId(citizenid) {
  return PARISHES[hashFromId(citizenid) % PARISHES.length]
}

function formatNationality(val) {
  if (!val) return "JAMAICA"
  const s = String(val).trim()
  if (/jamaica/i.test(s)) return "JAMAICA"
  return s.toUpperCase()
}

function formatSign(ime) {
  const { potpis } = parseIme(ime)
  return potpis
}

function fillPremiumCommon(card, playerData) {
  const punoIme = (playerData.ime || "NEPOZNATO").toUpperCase()
  const dates = ensureDates(playerData)

  setField(card, "puno_ime", punoIme)
  setField(card, "datum_rodjenja", playerData.datum_rodjenja)
  setField(card, "pol", formatPolShort(playerData.pol ?? playerData.sex))
  setField(card, "potpis", formatSign(playerData.ime))
  setField(card, "datum_isteka_exp", formatExpires(dates.expire))
  setField(card, "datum_izdavanja", dates.issued)
  setField(card, "issuedDate", dates.issued)
}

function updateIdCard(playerData, slika) {
  const card = document.getElementById("id-card")
  if (!card) return

  const citizenid = playerData.citizenid || "000000000"
  const docBroj = citizenid.toString().slice(-9).padStart(9, "0")

  fillPremiumCommon(card, playerData)
  setField(card, "nacionalnost", formatNationality(playerData.nacionalnost))
  setField(card, "parish", playerData.parish || parishFromId(citizenid))
  setField(card, "citizenid", citizenid)
  setField(card, "id_kod", `ID${docBroj}`)

  postaviSliku("player-photo", slika)
}

function updateDriverLicense(playerData, slika) {
  const card = document.getElementById("drivers-license")
  if (!card) return

  const citizenid = playerData.citizenid || ""
  const broj = (playerData.broj_dozvole || `JM${citizenid.toString().replace(/[^0-9A-Z]/gi, "").slice(-8)}`)
    .replace(/^DL-?/i, "")
    .toUpperCase()
  const ownedFromBadges = renderDlCategoryBadges(playerData.kategorijePregled)
  const lista =
    playerData.kategorijeLista ||
    ownedFromBadges ||
    playerData.kategorije

  fillPremiumCommon(card, playerData)
  setField(card, "broj_dozvole", broj)
  setField(card, "visina", playerData.visina || `${visinaIzId(citizenid)} cm`)
  setField(card, "kategorije", formatClass(lista))

  postaviSliku("player-photo2", slika)
}

const BADGE_JOB_CLASS = {
  police: "doc-badge--police",
}

function applyBadgeJobClass(card, tip) {
  card.classList.remove(
    "doc-badge--police"
  )
  const cls = BADGE_JOB_CLASS[tip] || BADGE_JOB_CLASS.police
  card.classList.add(cls)
  card.dataset.badgeJob = tip || "police"
}

function updateServiceBadge(playerData, slika) {
  const card = document.getElementById("service-badge")
  if (!card) return

  const tip = playerData.znacka_tip || playerData.posao || "police"
  applyBadgeJobClass(card, tip)

  const punoIme = (playerData.ime || "NEPOZNATO").toUpperCase()
  const dates = ensureDates(playerData)

  setField(card, "puno_ime", punoIme)
  setField(card, "sluzba", playerData.sluzba || "—")
  setField(card, "naslov", playerData.naslov || "—")
  setField(card, "podnaslov", playerData.podnaslov || "OFFICIAL BADGE")
  setField(card, "rang", playerData.rang || "—")
  setField(card, "pol", formatPolShort(playerData.pol ?? playerData.sex))
  setField(card, "broj_znacke", playerData.broj_znacke || "—")
  setField(card, "broj_dozvole", playerData.broj_dozvole || "—")
  setField(card, "datum_izdavanja", dates.issued)
  setField(card, "potpis", formatSign(playerData.ime))

  const sealEl = document.getElementById("badge-seal-text")
  if (sealEl && playerData.seal) {
    sealEl.innerHTML = String(playerData.seal).replace(/<br\s*\/?>/gi, "<br>")
  }

  postaviSliku("player-photo-badge", slika)
}

function updateWeaponPermit(playerData, slika) {
  const card = document.getElementById("weapon-permit")
  if (!card) return

  const citizenid = playerData.citizenid || ""
  const broj = (playerData.broj_dozvole || `WP${citizenid.toString().replace(/[^0-9A-Z]/gi, "").slice(-8)}`)
    .replace(/^WP-?/i, "")
    .toUpperCase()

  fillPremiumCommon(card, playerData)
  setField(card, "tip_oruzja", playerData.tip_oruzja || "SHORT FIREARM")
  setField(card, "broj_dozvole", broj)

  postaviSliku("player-photo3", slika)
}

function postaviSliku(elementId, slika) {
  const photo = document.getElementById(elementId)
  if (!photo) return

  if (!slika) {
    photo.onerror = null
    photo.removeAttribute("src")
    return
  }

  photo.onerror = () => {
    photo.onerror = null
    photo.removeAttribute("src")
  }
  photo.src = slika
}

window.addEventListener("message", (event) => {
  const data = event.data
  if (!data?.akcija) return

  switch (data.akcija) {
    case "licna_karta":
      prikaziDokument("id-card")
      if (data.info) updateIdCard(data.info, data.slika)
      break
    case "vozacka_dozvola":
      prikaziDokument("drivers-license")
      if (data.info) updateDriverLicense(data.info, data.slika)
      break
    case "oruzje_dozvola":
      prikaziDokument("weapon-permit")
      if (data.info) updateWeaponPermit(data.info, data.slika)
      break
    case "sluzbena_znacka":
      prikaziDokument("service-badge")
      if (data.info) updateServiceBadge(data.info, data.slika)
      break
  }
})

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    zatvoriSveDokumente()
    $.post("https://jamaica-dokumenti/zatvori", JSON.stringify({}))
  }
})
