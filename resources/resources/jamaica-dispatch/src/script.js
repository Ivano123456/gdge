let dispatchCounter = 0;
let activeDispatches = new Map();
let dispatchCoords = new Map();

function kreirajDispatch(title, description, location, tip, kod = '10-31') {
    dispatchCounter++;
    const dispatchId = `dispatch-${dispatchCounter}`;
    
    let tipClass = 'badge-sos';
    let tipText = 'SOS';
    let shouldPulse = false;

    switch(tip?.toLowerCase()) {
        case 'sos': tipClass='badge-sos'; tipText='SOS'; shouldPulse=true; break;
        case 'visok': tipClass='badge-visok'; tipText='VISOK'; shouldPulse=true; break;
        case 'srednji': tipClass='badge-srednji'; tipText='SREDNJI'; break;
        case 'nizak': tipClass='badge-nizak'; tipText='NIZAK'; break;
        default: tipClass='badge-sos'; tipText='SOS'; shouldPulse=true;
    }

    const container = document.createElement("div");
    container.className = "dispatch-container show";
    container.id = dispatchId;

    const header = document.createElement("div");
    header.className = "header";
    const logo = document.createElement("span");
    logo.className = "dispatch-logo";
    logo.textContent = "Policijska Centrala";
    header.appendChild(logo);

    const badges = document.createElement("div");
    badges.className = "badges";
    const tipBadge = document.createElement("span");
    tipBadge.className = `badge ${tipClass} ${shouldPulse ? "pulse" : ""}`;
    tipBadge.textContent = tipText;
    const kodBadge = document.createElement("span");
    kodBadge.className = "badge badge-code";
    kodBadge.textContent = kod;
    badges.appendChild(tipBadge);
    badges.appendChild(kodBadge);

    const content = document.createElement("div");
    content.className = "content";
    const titleEl = document.createElement("h2");
    titleEl.className = "title";
    titleEl.textContent = title;
    const descEl = document.createElement("p");
    descEl.className = "description";
    descEl.textContent = description;
    const locEl = document.createElement("p");
    locEl.className = "location";
    locEl.textContent = location;

    const actions = document.createElement("div");
    actions.className = "actions";

    const mapBtn = document.createElement("div");
    mapBtn.className = "action-btn";
    mapBtn.onclick = () => prikaziMapu(dispatchId);
    mapBtn.innerHTML = `<span class="key">M</span><span>Mapa</span>`;

    const acceptBtn = document.createElement("div");
    acceptBtn.className = "action-btn";
    acceptBtn.onclick = () => prihvatiDispatch(dispatchId);
    acceptBtn.innerHTML = `<span class="key">G</span><span>Prihvati</span>`;

    const cancelBtn = document.createElement("div");
    cancelBtn.className = "action-btn";
    cancelBtn.onclick = () => otkazaoDispatch(dispatchId);
    cancelBtn.innerHTML = `<span class="key">C</span><span>Odbij</span>`;

    actions.appendChild(mapBtn);
    actions.appendChild(acceptBtn);
    actions.appendChild(cancelBtn);

    content.appendChild(titleEl);
    content.appendChild(descEl);
    content.appendChild(locEl);
    content.appendChild(actions);

    container.appendChild(header);
    container.appendChild(badges);
    container.appendChild(content);

    const stack = document.getElementById('dispatchStack');
    stack.appendChild(container);

    const timeoutId = setTimeout(() => {
        ukloniDispatch(dispatchId);
    }, 60000); 

    activeDispatches.set(dispatchId, timeoutId);

    return dispatchId;
}

function ukloniDispatch(dispatchId) {
    dispatchCoords.delete(dispatchId);
    const dispatch = document.getElementById(dispatchId);
    if (dispatch) {
        if (activeDispatches.has(dispatchId)) {
            clearTimeout(activeDispatches.get(dispatchId));
            activeDispatches.delete(dispatchId);
        }

        dispatch.style.animation = 'slideOutNotification 0.3s ease-in forwards';
        setTimeout(() => {
            dispatch.classList.add('hidden');
            setTimeout(() => {
                dispatch.remove();
            }, 100);
        }, 300);
    }
}

function prikaziMapu(dispatchId) {
    const coords = dispatchCoords.get(dispatchId);
    ukloniDispatch(dispatchId);
    
    if (coords) {
        $.post(`https://jamaica-dispatch/prikaziMapu`, JSON.stringify({
            x: coords.x,
            y: coords.y,
            z: coords.z
        }));
    } else {
        $.post(`https://jamaica-dispatch/prikaziMapu`, JSON.stringify({}));
    }
}

function prihvatiDispatch(dispatchId) {
    const dispatch = document.getElementById(dispatchId);
    const coords = dispatchCoords.get(dispatchId);
    
    if (dispatch) {
        dispatch.style.borderColor = 'rgba(34, 197, 94, 0.5)';
        
        if (coords) {
            $.post(`https://jamaica-dispatch/prihvatiDispatch`, JSON.stringify({
                x: coords.x,
                y: coords.y,
                z: coords.z
            }));
        } else {
            $.post(`https://jamaica-dispatch/prihvatiDispatch`, JSON.stringify({}));
        }

        setTimeout(() => {
            ukloniDispatch(dispatchId);
        }, 1000);
    }
}

function otkazaoDispatch(dispatchId) {
    const coords = dispatchCoords.get(dispatchId);
    
    if (coords) {
        $.post(`https://jamaica-dispatch/otkazaoDispatch`, JSON.stringify({
            x: coords.x,
            y: coords.y,
            z: coords.z
        }));
    } else {
        $.post(`https://jamaica-dispatch/otkazaoDispatch`, JSON.stringify({}));
    }

    ukloniDispatch(dispatchId);
}

function getajZadnjiId() {
    const visibleDispatches = document.querySelectorAll('.dispatch-container:not(.hidden)');
    if (visibleDispatches.length === 0) return null;

    const latestDispatch = visibleDispatches[visibleDispatches.length - 1];
    return latestDispatch.id;
}

window.addEventListener("message", (event) => {
    const akcija = event.data.akcija;

    switch (akcija) {
        case "show": {
            const title = event.data.title || "Dojava od strane civila";
            const description = event.data.description || "Dojava u toku";
            const location = event.data.ulica || "Lokacija oznacena na mapi";
            const tip = event.data.tip || "sos";
            const kod = event.data.kod || "10-31";
            const coords = event.data.coords || null;
        
            const dispatchId = kreirajDispatch(title, description, location, tip, kod);
            if (coords) {
                dispatchCoords.set(dispatchId, coords);
            }
            break;
        }

        case "pritisnuo_g": {
            const dispatchId = getajZadnjiId();
            if (dispatchId) {
                prihvatiDispatch(dispatchId);
            }
            break;
        }

        case "pritisnuo_c": {
            const dispatchId = getajZadnjiId();
            if (dispatchId) otkazaoDispatch(dispatchId);
            break;
        }

        case "pritisnuo_m": {
            const dispatchId = getajZadnjiId();
            if (dispatchId) prikaziMapu(dispatchId);
            break;
        }

        default:
            break;
    }
});