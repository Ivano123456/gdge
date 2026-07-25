const FILLERS = ['👜', '🏆', '🍾', '🎁', '👑', '💍', '⌚', '⭐', '🎸'];

const shuffleArray = (a) => {
  const arr = a.slice();
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
};

const buildBoard = (canWin) => {
  const board = [];
  const diamondCount = canWin ? 3 : Math.floor(Math.random() * 3);

  for (let i = 0; i < diamondCount; i++) {
    board.push('💎');
  }

  while (board.length < 9) {
    board.push(FILLERS[Math.floor(Math.random() * FILLERS.length)]);
  }

  return shuffleArray(board);
};

window.startSreckaGame = (canWin) => {
  const emojiContainer = document.querySelector('.emoji-container');
  const emojiOutput = document.querySelectorAll('.emoji-output');
  const dialogBox = document.querySelector('.dialog-box');
  const dialogMessage = document.querySelector('.dialog-message');
  const bellSound1 = document.querySelector('.bell-sound-1');
  const bellSound2 = document.querySelector('.bell-sound-2');
  const bellSound3 = document.querySelector('.bell-sound-3');
  const winSound = document.querySelector('.win-sound');
  const loseSound = document.querySelector('.lose-sound');

  const board = buildBoard(canWin);
  let winningEmojisFound = 0;
  let emojisRemaining = 9;
  const message = canWin
    ? 'Čestitamo osvojili ste novčanu nagradu!'
    : 'Izgubili ste.';

  emojiOutput.forEach((emoji, i) => {
    emoji.textContent = board[i];
  });

  document.querySelectorAll('.emoji-btn').forEach((btn) => {
    btn.classList.remove('uncovered', 'winning-emoji');
  });

  dialogBox.classList.remove('show-dialog');
  dialogMessage.textContent = '';
  document.querySelectorAll('.dollar-bill').forEach((el) => el.remove());

  const onClick = (e) => {
    const target = e.target.closest('.emoji-btn');

    if (!target || target.classList.contains('uncovered')) {
      return;
    }

    emojisRemaining--;
    target.classList.add('uncovered');

    if (target.querySelector('.emoji-output').textContent === '💎') {
      target.classList.add('winning-emoji');

      switch (winningEmojisFound) {
        case 0:
          bellSound1.play();
          break;
        case 1:
          bellSound2.play();
          break;
        case 2:
          bellSound3.play();
          break;
      }

      winningEmojisFound++;
    }

    if (emojisRemaining === 0) {
      emojiContainer.removeEventListener('click', onClick);

      setTimeout(() => {
        if (canWin) {
          winSound.play();
          setTimeout(() => {
            const w = window.innerWidth;
            for (let i = 0; i < 70; i++) {
              const dollar = document.createElement('div');
              dollar.classList.add('dollar-bill');
              dollar.textContent = '💵';
              dollar.style.left = `${Math.floor(Math.random() * w)}px`;
              document.body.appendChild(dollar);
            }
          }, 1200);
          $.post('https://jamaica-srecka/win', JSON.stringify({}));
        } else {
          loseSound.play();
        }
      }, 1500);

      dialogBox.classList.add('show-dialog');
      dialogMessage.textContent = message;
    }
  };

  emojiContainer.removeEventListener('click', onClick);
  emojiContainer.addEventListener('click', onClick);
};
