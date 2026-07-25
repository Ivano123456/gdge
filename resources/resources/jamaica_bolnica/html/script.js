(() => {
    let totalTime = 60;
    let currentTime = 0;
    let hospitalAvailable = true;

    const deathScreen = document.getElementById('deathScreen');
    const timerLabel = document.getElementById('timerLabel');
    const timerText = document.getElementById('timerText');
    const progressBar = document.getElementById('progressBar');
    const hospitalRow = document.getElementById('hospitalRow');
    const respawnRow = document.getElementById('respawnRow');
    const deathSound = document.getElementById('deathSound');

    function formatTime(seconds) {
        const s = Math.max(0, Math.floor(seconds));
        const min = Math.floor(s / 60);
        const sec = s % 60;
        return `${String(min).padStart(2, '0')}:${String(sec).padStart(2, '0')}`;
    }

    function playDeathSound() {
        if (!deathSound) return;
        deathSound.pause();
        deathSound.currentTime = 0;
        deathSound.volume = 0.65;
        deathSound.play().catch(() => {});
    }

    function stopDeathSound() {
        if (!deathSound) return;
        deathSound.pause();
        deathSound.currentTime = 0;
    }

    function updateDisplay() {
        const canRespawn = currentTime <= 0;

        if (canRespawn) {
            timerLabel.textContent = 'Respawn';
            timerText.textContent = 'Spreman';
            timerText.classList.add('ready');
            progressBar.style.width = '100%';
        } else {
            timerLabel.textContent = 'Respawn za';
            timerText.textContent = formatTime(currentTime);
            timerText.classList.remove('ready');
            const pct = totalTime > 0 ? ((totalTime - currentTime) / totalTime) * 100 : 0;
            progressBar.style.width = `${Math.min(100, Math.max(0, pct))}%`;
        }

        respawnRow.classList.toggle('hidden', !canRespawn);
        hospitalRow.classList.toggle('hidden', canRespawn || !hospitalAvailable);
    }

    function updateHospital(canCall) {
        hospitalAvailable = !!canCall;
        updateDisplay();
    }

    function showDeathScreen(seconds) {
        if (typeof seconds === 'number' && seconds >= 0) {
            totalTime = seconds > 0 ? seconds : 60;
            currentTime = seconds;
        }

        const wasHidden = deathScreen.classList.contains('hidden');
        deathScreen.classList.remove('hidden');

        if (wasHidden) {
            playDeathSound();
        }

        updateDisplay();
    }

    function hideDeathScreen() {
        deathScreen.classList.add('hidden');
        currentTime = 0;
        hospitalAvailable = true;
        stopDeathSound();
    }

    function setRemainingTime(seconds) {
        if (typeof seconds !== 'number') return;
        currentTime = Math.max(0, seconds);
        if (currentTime > totalTime) {
            totalTime = currentTime;
        }
        updateDisplay();
    }

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (!data || typeof data !== 'object') return;

        if (data.Ekran === true) {
            showDeathScreen(data.Sekunde);
        } else if (data.Ekran === false) {
            hideDeathScreen();
        }

        if (data.Sekunde !== undefined && data.Ekran !== true) {
            setRemainingTime(data.Sekunde);
        }

        if (data.Bolnica !== undefined) {
            updateHospital(data.Bolnica);
        }
    });

    document.addEventListener('keydown', (event) => {
        if (deathScreen.classList.contains('hidden')) return;
        if (event.key.toLowerCase() !== 'h') return;
        if (hospitalRow.classList.contains('hidden')) return;

        hospitalAvailable = false;
        updateDisplay();
    });

    hideDeathScreen();
})();
