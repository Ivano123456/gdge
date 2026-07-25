let arrow = document.querySelector('.moving-arrow');
let targetZone = document.querySelector('.target-zone');
const container = document.querySelector(".container");
let leftCounter = document.querySelector(".left-counter p");
let rightCounter = document.querySelector(".right-counter p");
let movingRight = true;
let gameRunning = true;
let speed = null;
let counter = null;

let passed = false;



function post(options) {
  options.data = options.data || {};
  $.post(`https://d3MBA-moneyprint/` + options.action, JSON.stringify(options.data));
}

function updateCounterDisplay() {
    leftCounter.textContent = counter;
    rightCounter.textContent = counter;
}


function randomTargetZone() {
    targetZone.style.width = `${Math.floor(Math.random() * (100 - 50 + 1)) + 50}px`;
    targetZone.style.left = `${Math.floor(Math.random() * (350 / 10 + 1)) * 10}px`;
}

function moveArrow() {
    if (!gameRunning) return;
    let arrowPos = parseInt(window.getComputedStyle(arrow).left);
    let containerWidth = document.querySelector('.game-container').clientWidth;

    if (movingRight) {
        arrow.style.left = arrowPos + speed + 'px';
        if (arrowPos + 40 >= containerWidth) movingRight = false;
    } else {
        arrow.style.left = arrowPos - speed + 'px';
        if (arrowPos <= 0) movingRight = true;
    }
}

function resetGame() {
    arrow.style.left = '0px';
    movingRight = true;
    gameRunning = true;
    gameLoop = setInterval(moveArrow, 16);
    randomTargetZone()
}

function closeMinigameUi() {
    container.classList.add("closing");
    setTimeout(() => {
        container.classList.remove("active", "closing");
        post({ action: "close" });
    }, 300); // wait for animation to finish
}

function changeCounter() {
    leftCounter.textContent = counter;
    rightCounter.textContent = counter;
}

let gameLoop = setInterval(moveArrow, 16);

document.addEventListener('keydown', (event) => {
    if (event.code === 'Space' && gameRunning) {
        gameRunning = false;
        clearInterval(gameLoop);
        checkIfInside();
    }
});

window.addEventListener("message", (event) => {
  if (event.data.action === "open") {
    container.classList.add("active");
    counter = event.data.numberOfRotations
    speed = event.data.speed

    updateCounterDisplay();
    
  } else if (event.data.action === "close") {
    container.classList.remove("active");
    closeMinigameUi();
  }
});

function checkIfInside() {
    let arrowPos = parseInt(window.getComputedStyle(arrow).left);
    let targetLeft = parseInt(window.getComputedStyle(targetZone).left);
    let targetRight = targetLeft + targetZone.clientWidth;

    if (arrowPos >= targetLeft && arrowPos + 40 <= targetRight) {
        passed = true;

        counter--;

        changeCounter();

        if (counter === 0) {
            container.classList.remove("active");
            const options = {
            action: "close",
            };
            post(options);

            const options2 = {
                action: "success",
            };
            post(options2);
            updateCounterDisplay();
        }
    } else {
        passed = false;

        const options = {
            action: "failed",
        };
        post(options);
        setTimeout(closeMinigameUi, 500);

    }
    setTimeout(resetGame, 500);
}