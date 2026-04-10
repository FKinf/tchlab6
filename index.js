const fs = require('fs');
const os = require('os');

const VERSION = process.env.APP_VERSION || 'unknown';

const getLocalIP = () => {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return '127.0.0.1';
};

const html = `<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Lab5 - Info Serwera</title>
</head>
<body>
  <div class="card">
    <h1>Informacje o Serwerze</h1>
    <div class="info"><span class="label">Adres IP:</span> <span class="value">${getLocalIP()}</span></div>
    <div class="info"><span class="label">Hostname:</span> <span class="value">${os.hostname()}</span></div>
    <div class="info"><span class="label">Wersja aplikacji:</span> <span class="value">${VERSION}</span></div>
  </div>
</body>
</html>`;

fs.writeFileSync('/output/index.html', html);
console.log(`Plik index.html wygenerowany, wersja: ${VERSION}`);
