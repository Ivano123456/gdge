const LICENSE_INFO = {
    bike: {
        title: 'Motocikli i mopedi',
        desc: 'Obuka za vožnju dvotočkaša u gradskom i vangradskom saobraćaju.'
    },
    car: {
        title: 'Putnička vozila',
        desc: 'Standardna B kategorija za automobile i lakša putnička vozila.'
    },
    truck: {
        title: 'Teretna vozila',
        desc: 'C kategorija za kamione i vozila veće nosivosti.'
    }
};

const app = new Vue({
    el: '#app',
    data: {
        resourceName: GetParentResourceName(),
        screen: 'license',
        activeLicense: null,
        allQuestions: [],
        questionQueue: [],
        licenses: [],
        userLicense: [],
        currentQuestion: null,
        selectedIndex: null,
        selectedLicense: null,
        score: 0,
        descriptionTitle: '',
        minPoints: 1,
        doingTheory: false,
        doingPractice: false,
        testFailed: false,
        isLoading: false,
        theoryIndex: 0,
        config: {
            Lang: {}
        },
        money: 0,
        bank: 0
    },
    computed: {
        activeLicenseData() {
            if (!this.activeLicense) {
                return this.licenses[0] || null;
            }
            return this.licenses.find((item) => item.id === this.activeLicense) || this.licenses[0] || null;
        },
        theoryProgress() {
            if (!this.allQuestions.length) {
                return 0;
            }
            return Math.min(100, (this.theoryIndex / this.allQuestions.length) * 100);
        }
    },
    methods: {
        postMessage(type, data = {}) {
            return $.post(`https://${this.resourceName}/${type}`, JSON.stringify(data));
        },
        formatMoney(value) {
            return `${Number(value || 0).toLocaleString('sr-RS')}$`;
        },
        getLicenseState(licenseId) {
            const found = this.userLicense.find((entry) => entry.id === licenseId);
            if (!found) {
                return 'theory';
            }
            if (found.theory && found.practice) {
                return 'done';
            }
            if (found.theory) {
                return 'practice';
            }
            return 'theory';
        },
        getStatusLabel(licenseId) {
            const state = this.getLicenseState(licenseId);
            if (state === 'done') {
                return 'Licenca stečena';
            }
            if (state === 'practice') {
                return 'Teorija položena';
            }
            return 'Spremno za teoriju';
        },
        getBadgeText(licenseId) {
            const state = this.getLicenseState(licenseId);
            if (state === 'done') {
                return 'OK';
            }
            if (state === 'practice') {
                return '2/3';
            }
            return '1/3';
        },
        getLicenseTitle(licenseId) {
            return LICENSE_INFO[licenseId]?.title || 'Vozačka kategorija';
        },
        getLicenseDesc(licenseId) {
            return LICENSE_INFO[licenseId]?.desc || '';
        },
        isStepDone(step) {
            const licenseId = this.activeLicenseData?.id;
            if (!licenseId) {
                return false;
            }
            const state = this.getLicenseState(licenseId);
            if (step === 'theory') {
                return state === 'practice' || state === 'done';
            }
            if (step === 'practice') {
                return state === 'done';
            }
            return false;
        },
        getLocalizedMessage(reason, missing = 0) {
            if (reason === 'money') {
                return this.config.Lang.money_error.replace('%s', missing);
            }
            if (reason === 'theory_required') {
                return this.config.Lang.theory_before;
            }
            if (reason === 'theory_done') {
                return this.config.Lang.already_done;
            }
            if (reason === 'practice_done') {
                return 'Praktični ispit je već završen.';
            }
            return 'Trenutno nije moguće pokrenuti ispit.';
        },
        showTemporaryDescription(message) {
            this.descriptionTitle = message;
            setTimeout(() => {
                if (this.screen === 'license') {
                    this.descriptionTitle = '';
                }
            }, 5000);
        },
        pickQuestionSet() {
            const questionsBySet = this.config.Question[this.config.Language] || {};
            const keys = Object.keys(questionsBySet);
            if (!keys.length) {
                this.allQuestions = [];
                return;
            }
            const randomKey = keys[Math.floor(Math.random() * keys.length)];
            this.allQuestions = questionsBySet[randomKey].map((question) => ({ ...question }));
        },
        nextTheoryQuestion() {
            this.selectedIndex = null;

            if (!this.questionQueue.length) {
                this.currentQuestion = null;
                this.screen = 'result';

                if (this.score >= this.minPoints) {
                    this.postMessage('theoryOk', { license: this.selectedLicense }).then((result) => {
                        if (result?.ok) {
                            this.descriptionTitle = this.config.Lang.theory_success;
                            this.testFailed = false;
                        } else {
                            this.descriptionTitle = 'Greška pri čuvanju rezultata. Otvori meni ponovo.';
                            this.testFailed = true;
                        }
                    });
                } else {
                    this.descriptionTitle = this.config.Lang.theory_error;
                    this.testFailed = true;
                }
                return;
            }

            this.currentQuestion = this.questionQueue.shift();
            this.theoryIndex += 1;
        },
        submitTheoryAnswer() {
            if (this.selectedIndex === null || !this.currentQuestion) {
                return;
            }

            if (this.currentQuestion.options[this.selectedIndex]?.correct) {
                this.score += 1;
            }

            this.nextTheoryQuestion();
        },
        async startTheory(licenseId) {
            if (this.isLoading) {
                return;
            }

            this.isLoading = true;
            const response = await this.postMessage('startTheory', { license: licenseId });
            this.isLoading = false;

            if (!response?.ok) {
                this.showTemporaryDescription(this.getLocalizedMessage(response?.reason, response?.missing));
                return;
            }

            this.selectedLicense = licenseId;
            this.activeLicense = licenseId;
            this.doingTheory = true;
            this.doingPractice = false;
            this.testFailed = false;
            this.score = 0;
            this.theoryIndex = 0;
            this.questionQueue = [...this.allQuestions].sort(() => Math.random() - 0.5);
            this.screen = 'theory';
            this.nextTheoryQuestion();
        },
        async startPractice(licenseId) {
            if (this.isLoading) {
                return;
            }

            this.isLoading = true;
            const response = await this.postMessage('startPractice', { license: licenseId });
            this.isLoading = false;

            if (!response?.ok) {
                this.showTemporaryDescription(this.getLocalizedMessage(response?.reason, response?.missing));
                return;
            }

            this.selectedLicense = licenseId;
            this.doingTheory = false;
            this.doingPractice = true;
            this.testFailed = false;
            $('#app').fadeOut(400);
            this.postMessage('close');
        },
        close() {
            const passedTheory = this.screen === 'result' && this.doingTheory && !this.testFailed;

            if (passedTheory) {
                this.screen = 'license';
                this.doingTheory = false;
                this.doingPractice = false;
                this.testFailed = false;
                this.selectedIndex = null;
                this.currentQuestion = null;
                this.descriptionTitle = this.config.Lang.theory_success;
                this.theoryIndex = 0;
                this.postMessage('refreshData');
                return;
            }

            $('#app').fadeOut(350, () => {
                this.screen = 'license';
                this.doingTheory = false;
                this.doingPractice = false;
                this.testFailed = false;
                this.selectedIndex = null;
                this.currentQuestion = null;
                this.descriptionTitle = '';
                this.theoryIndex = 0;
            });
            this.postMessage('close');
        }
    }
});

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'OPEN') {
        app.userLicense = data.licenses || [];
        app.licenses = data.license || [];
        app.activeLicense = app.licenses[0]?.id || null;
        app.screen = 'license';
        app.descriptionTitle = '';
        $('#app').fadeIn(300);
        return;
    }

    if (data.type === 'UPDATE_LICENSE') {
        app.userLicense = data.licenses || [];
        return;
    }

    if (data.type === 'SET_CONFIG') {
        app.config = data.config;
        app.config.Lang = app.config.Lang[app.config.Language] || {};
        app.minPoints = data.config.PuntiMinimi;
        app.pickQuestionSet();
        return;
    }

    if (data.type === 'SET_MONEY') {
        app.money = data.contanti || 0;
        app.bank = data.banca || 0;
        return;
    }

    if (data.type === 'UPDATE_HUD') {
        $('#driving-hud').fadeIn(120);
        const speedValue = document.getElementById('speed-value');
        const errorValue = document.getElementById('error-value');

        speedValue.innerHTML = `${data.speed} / ${data.maxSpeed}<span class="hud-unit">km/h</span>`;
        speedValue.classList.toggle('speed-over', data.speed > data.maxSpeed);

        errorValue.textContent = `${data.errors} / ${data.maxErrors}`;
        errorValue.classList.remove('error-warning', 'error-danger');
        if (data.errors >= data.maxErrors) {
            errorValue.classList.add('error-danger');
        } else if (data.errors >= data.maxErrors - 1) {
            errorValue.classList.add('error-warning');
        }
        return;
    }

    if (data.type === 'HIDE_HUD') {
        $('#driving-hud').fadeOut(120);
        return;
    }

    if (data.type === 'DISPLAY_RISULTATO') {
        app.score = data.errori;
        app.doingPractice = true;
        app.doingTheory = false;
        app.testFailed = data.errori >= app.config.MaxErrors;
        app.descriptionTitle = app.testFailed ? app.config.Lang.practice_error : app.config.Lang.practice_success;
        app.screen = 'result';
        $('#app').fadeIn(350);
    }
});

document.onkeyup = (event) => {
    if (event.key === 'Escape' && app.screen === 'license') {
        app.close();
    }
};
