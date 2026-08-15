// MIT App Inventor Soccer Game Canvas & Logic Simulator

const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

const scoreVal = document.getElementById('score-val');
const highScoreVal = document.getElementById('high-score-val');
const statusBanner = document.getElementById('status-banner');
const resetBtn = document.getElementById('reset-btn');

// Game State Variables (matches App Inventor global variables)
let score = 0;
let highScore = 0;
let keeperSpeed = 3.5;

// Sound Effects via Web Audio API (No external sound files required)
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

function playGoalSound() {
  if (audioCtx.state === 'suspended') audioCtx.resume();
  const osc = audioCtx.createOscillator();
  const gain = audioCtx.createGain();
  osc.type = 'triangle';
  osc.frequency.setValueAtTime(440, audioCtx.currentTime);
  osc.frequency.exponentialRampToValueAtTime(880, audioCtx.currentTime + 0.3);
  gain.gain.setValueAtTime(0.3, audioCtx.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.5);
  osc.connect(gain);
  gain.connect(audioCtx.destination);
  osc.start();
  osc.stop(audioCtx.currentTime + 0.5);
}

function playSaveSound() {
  if (audioCtx.state === 'suspended') audioCtx.resume();
  const osc = audioCtx.createOscillator();
  const gain = audioCtx.createGain();
  osc.type = 'sawtooth';
  osc.frequency.setValueAtTime(200, audioCtx.currentTime);
  osc.frequency.linearRampToValueAtTime(100, audioCtx.currentTime + 0.25);
  gain.gain.setValueAtTime(0.3, audioCtx.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.3);
  osc.connect(gain);
  gain.connect(audioCtx.destination);
  osc.start();
  osc.stop(audioCtx.currentTime + 0.3);
}

// Components Definitions
const goalNet = {
  x: 90,
  y: 20,
  width: 200,
  height: 65
};

const goalkeeper = {
  x: 165,
  y: 50,
  width: 50,
  height: 50,
  minX: 90,
  maxX: 240
};

const ball = {
  startX: 190,
  startY: 430,
  x: 190,
  y: 430,
  radius: 16,
  vx: 0,
  vy: 0,
  isMoving: false
};

// Drag / Fling Control
let isDragging = false;
let dragStartX = 0;
let dragStartY = 0;
let currentMouseX = 0;
let currentMouseY = 0;

// Particle System for Goal Explosion
let particles = [];

function createGoalParticles(x, y) {
  particles = [];
  const colors = ['#fbbf24', '#f59e0b', '#38bdf8', '#ffffff', '#10b981'];
  for (let i = 0; i < 35; i++) {
    particles.push({
      x: x,
      y: y,
      vx: (Math.random() - 0.5) * 10,
      vy: (Math.random() - 0.5) * 10,
      radius: Math.random() * 5 + 3,
      color: colors[Math.floor(Math.random() * colors.length)],
      alpha: 1,
      life: 1
    });
  }
}

// Reset Ball Position (matches Procedure ResetBallPosition)
function resetBallPosition() {
  ball.x = ball.startX;
  ball.y = ball.startY;
  ball.vx = 0;
  ball.vy = 0;
  ball.isMoving = false;
}

// Input Handlers (Simulates App Inventor SoccerBall.Flung)
function handlePointerDown(e) {
  if (ball.isMoving) return;
  const rect = canvas.getBoundingClientRect();
  const px = (e.touches ? e.touches[0].clientX : e.clientX) - rect.left;
  const py = (e.touches ? e.touches[0].clientY : e.clientY) - rect.top;

  const dist = Math.hypot(px - ball.x, py - ball.y);
  if (dist <= ball.radius + 20) {
    isDragging = true;
    dragStartX = px;
    dragStartY = py;
    currentMouseX = px;
    currentMouseY = py;
  }
}

function handlePointerMove(e) {
  if (!isDragging) return;
  const rect = canvas.getBoundingClientRect();
  currentMouseX = (e.touches ? e.touches[0].clientX : e.clientX) - rect.left;
  currentMouseY = (e.touches ? e.touches[0].clientY : e.clientY) - rect.top;
}

function handlePointerUp(e) {
  if (!isDragging) return;
  isDragging = false;

  const dx = currentMouseX - dragStartX;
  const dy = currentMouseY - dragStartY;
  const distance = Math.hypot(dx, dy);

  // Trigger shot if drag distance is sufficient
  if (distance > 15 && dy < 0) {
    const speedMultiplier = 0.18;
    ball.vx = dx * speedMultiplier;
    ball.vy = dy * speedMultiplier;

    // Cap velocity
    const speed = Math.hypot(ball.vx, ball.vy);
    if (speed > 18) {
      ball.vx = (ball.vx / speed) * 18;
      ball.vy = (ball.vy / speed) * 18;
    }

    ball.isMoving = true;
  }
}

canvas.addEventListener('mousedown', handlePointerDown);
canvas.addEventListener('mousemove', handlePointerMove);
window.addEventListener('mouseup', handlePointerUp);

canvas.addEventListener('touchstart', handlePointerDown);
canvas.addEventListener('touchmove', handlePointerMove);
window.addEventListener('touchend', handlePointerUp);

// Reset Button Handler
resetBtn.addEventListener('click', () => {
  score = 0;
  scoreVal.textContent = '0';
  statusBanner.className = 'status-banner';
  statusBanner.textContent = '⚽ Game Reset! Swipe ball to shoot!';
  resetBallPosition();
});

// Update Loop (Simulates GoalkeeperClock.Timer & Physics Engine)
function update() {
  // 1. Goalkeeper patrol AI (GoalkeeperClock.Timer)
  goalkeeper.x += keeperSpeed;
  if (goalkeeper.x >= goalkeeper.maxX) {
    goalkeeper.x = goalkeeper.maxX;
    keeperSpeed = -Math.abs(keeperSpeed);
  } else if (goalkeeper.x <= goalkeeper.minX) {
    goalkeeper.x = goalkeeper.minX;
    keeperSpeed = Math.abs(keeperSpeed);
  }

  // 2. Ball Physics Update
  if (ball.isMoving) {
    ball.x += ball.vx;
    ball.y += ball.vy;

    // Friction & Gravity simulation
    ball.vx *= 0.985;
    ball.vy *= 0.985;

    // A. Collision with Goalkeeper (Goalkeeper catch!)
    if (
      ball.x + ball.radius >= goalkeeper.x &&
      ball.x - ball.radius <= goalkeeper.x + goalkeeper.width &&
      ball.y + ball.radius >= goalkeeper.y &&
      ball.y - ball.radius <= goalkeeper.y + goalkeeper.height
    ) {
      playSaveSound();
      statusBanner.className = 'status-banner saved';
      statusBanner.textContent = '🧤 SAVED! Goalkeeper caught it!';
      resetBallPosition();
    }
    // B. Collision with Goal Net (GOAL!)
    else if (
      ball.x + ball.radius >= goalNet.x &&
      ball.x - ball.radius <= goalNet.x + goalNet.width &&
      ball.y + ball.radius >= goalNet.y &&
      ball.y - ball.radius <= goalNet.y + goalNet.height
    ) {
      playGoalSound();
      createGoalParticles(ball.x, ball.y);
      score += 1;
      scoreVal.textContent = score;
      if (score > highScore) {
        highScore = score;
        highScoreVal.textContent = highScore;
      }
      statusBanner.className = 'status-banner goal';
      statusBanner.textContent = '🎉 GOAL! Fantastic Shot!';
      resetBallPosition();
    }
    // C. Top / Side Out of bounds
    else if (ball.y - ball.radius <= 0) {
      statusBanner.className = 'status-banner saved';
      statusBanner.textContent = '❌ OUT! Shot went over the bar!';
      resetBallPosition();
    } else if (ball.x - ball.radius <= 0 || ball.x + ball.radius >= canvas.width) {
      ball.vx = -ball.vx * 0.8; // Bounce off side posts
    }
  }

  // Update Goal particles
  particles.forEach((p, idx) => {
    p.x += p.vx;
    p.y += p.vy;
    p.alpha -= 0.02;
    if (p.alpha <= 0) particles.splice(idx, 1);
  });
}

// Rendering Function
function render() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // 1. Draw Grass Stripes
  const stripeHeight = 40;
  for (let i = 0; i < canvas.height; i += stripeHeight) {
    ctx.fillStyle = (i / stripeHeight) % 2 === 0 ? '#15803d' : '#166534';
    ctx.fillRect(0, i, canvas.width, i + stripeHeight);
  }

  // 2. Penalty Box & Markings
  ctx.strokeStyle = 'rgba(255, 255, 255, 0.7)';
  ctx.lineWidth = 3;

  // Goal Area Outer Box
  ctx.strokeRect(50, 10, 280, 140);
  ctx.strokeRect(110, 10, 160, 60);

  // Penalty Spot
  ctx.fillStyle = '#ffffff';
  ctx.beginPath();
  ctx.arc(190, 430, 4, 0, Math.PI * 2);
  ctx.fill();

  // Penalty Arc
  ctx.beginPath();
  ctx.arc(190, 150, 45, 0.2 * Math.PI, 0.8 * Math.PI);
  ctx.stroke();

  // 3. Goal Net Graphic
  ctx.fillStyle = 'rgba(255, 255, 255, 0.15)';
  ctx.fillRect(goalNet.x, goalNet.y, goalNet.width, goalNet.height);
  ctx.strokeStyle = '#ffffff';
  ctx.lineWidth = 4;
  ctx.strokeRect(goalNet.x, goalNet.y, goalNet.width, goalNet.height);

  // Net Grid Pattern
  ctx.lineWidth = 1;
  ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
  for (let x = goalNet.x; x <= goalNet.x + goalNet.width; x += 15) {
    ctx.beginPath(); ctx.moveTo(x, goalNet.y); ctx.lineTo(x, goalNet.y + goalNet.height); ctx.stroke();
  }
  for (let y = goalNet.y; y <= goalNet.y + goalNet.height; y += 12) {
    ctx.beginPath(); ctx.moveTo(goalNet.x, y); ctx.lineTo(goalNet.x + goalNet.width, y); ctx.stroke();
  }

  // 4. Goalkeeper Sprite Drawing
  const gk = goalkeeper;
  // Goalkeeper shadow
  ctx.fillStyle = 'rgba(0, 0, 0, 0.3)';
  ctx.beginPath();
  ctx.ellipse(gk.x + gk.width / 2, gk.y + gk.height - 2, 22, 6, 0, 0, Math.PI * 2);
  ctx.fill();

  // Jersey Body
  ctx.fillStyle = '#f59e0b';
  ctx.beginPath();
  ctx.roundRect(gk.x + 10, gk.y + 16, 30, 24, 6);
  ctx.fill();

  // Head
  ctx.fillStyle = '#fde047';
  ctx.beginPath();
  ctx.arc(gk.x + 25, gk.y + 10, 10, 0, Math.PI * 2);
  ctx.fill();

  // Gloves / Arms outstretched
  ctx.fillStyle = '#ef4444';
  ctx.beginPath();
  ctx.arc(gk.x + 4, gk.y + 22, 7, 0, Math.PI * 2); // Left glove
  ctx.arc(gk.x + 46, gk.y + 22, 7, 0, Math.PI * 2); // Right glove
  ctx.fill();

  // 5. Aim Trajectory Arrow (While dragging)
  if (isDragging) {
    const dx = dragStartX - currentMouseX;
    const dy = dragStartY - currentMouseY;
    ctx.strokeStyle = '#f59e0b';
    ctx.lineWidth = 4;
    ctx.setLineDash([6, 6]);
    ctx.beginPath();
    ctx.moveTo(ball.x, ball.y);
    ctx.lineTo(ball.x + dx, ball.y + dy);
    ctx.stroke();
    ctx.setLineDash([]);
  }

  // 6. Soccer Ball Drawing
  // Ball Shadow
  ctx.fillStyle = 'rgba(0, 0, 0, 0.35)';
  ctx.beginPath();
  ctx.ellipse(ball.x, ball.y + ball.radius - 2, ball.radius * 0.9, 5, 0, 0, Math.PI * 2);
  ctx.fill();

  // Ball Body
  ctx.fillStyle = '#ffffff';
  ctx.beginPath();
  ctx.arc(ball.x, ball.y, ball.radius, 0, Math.PI * 2);
  ctx.fill();
  ctx.lineWidth = 2;
  ctx.strokeStyle = '#0f172a';
  ctx.stroke();

  // Pentagons on Soccer Ball
  ctx.fillStyle = '#0f172a';
  ctx.beginPath();
  ctx.arc(ball.x, ball.y, ball.radius * 0.35, 0, Math.PI * 2);
  ctx.fill();

  ctx.beginPath();
  ctx.arc(ball.x - 8, ball.y - 7, 3, 0, Math.PI * 2);
  ctx.arc(ball.x + 8, ball.y - 7, 3, 0, Math.PI * 2);
  ctx.arc(ball.x - 9, ball.y + 6, 3, 0, Math.PI * 2);
  ctx.arc(ball.x + 9, ball.y + 6, 3, 0, Math.PI * 2);
  ctx.fill();

  // 7. Goal Particles
  particles.forEach(p => {
    ctx.save();
    ctx.globalAlpha = p.alpha;
    ctx.fillStyle = p.color;
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
  });
}

// Main Game Loop
function gameLoop() {
  update();
  render();
  requestAnimationFrame(gameLoop);
}

gameLoop();
